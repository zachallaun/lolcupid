!function() {

  const { Component, PropTypes } = React;
  const { createStore, compose, applyMiddleware } = Redux;
  const { Provider, connect } = ReactRedux;

  const DEFAULT_CHAMP_IMAGE_URL = 'https://ddragon.leagueoflegends.com/cdn/6.9.1/img/profileicon/16.png';

  /*** Helpers ***/

  const API = {
    recommendations: {
      search: (queryString) => {
        return fetch('/api/recommendations' + queryString).then(r => r.json());
      },
    },
  };

  function championsToQueryString(champions) {
    const championNames = champions.map(c => c.name.replace(' ', '_')).join(',');
    return `?name=${championNames}`;
  }

  // Top 5 recommendations for each role:
  // [{role: 'Top', recommendations: [...]}, ...]
  function recommendationsByRole(recommendations) {
    const roleMapping = [
      ['can_top', 'Top'],
      ['can_jungle', 'Jungle'],
      ['can_mid', 'Middle'],
      ['can_bot_carry', 'Bottom Carry'],
      ['can_bot_support', 'Support'],
    ];

    return roleMapping.map(([attr, role]) => ({
      role,
      recommendations: _(recommendations).filter(attr).take(5).value()
    }));
  }

  function setLocationQuery(query) {
    if (window.history && window.history.pushState) {
      window.history.pushState(null, null, location.pathname + query);
    }
  }

  /*** Actions ***/

  let Actions = {};

  Actions.fetchRecommendations = (champions) => {
    const query = championsToQueryString(champions);
    setLocationQuery(query);

    return {
      types: [
        'fetchRecommendations',
        'fetchRecommendationsSuccess',
        'fetchRecommendationsFailure',
      ],
      promise: () => API.recommendations.search(query),
      champions,
    };
  };

  Actions.selectChampion = (champion) => {
    return {
      type: 'selectChampion',
      champion,
    };
  }

  /*** State management ***/

  let Handlers = {};

  Handlers.fetchRecommendations = (state, { champions }) => ({
    ...state,
    queryChampions: champions,
  });

  Handlers.fetchRecommendationsSuccess = (state, { result }) => ({
    ...state,
    recommendations: result.recommendations,
  });

  Handlers.selectChampion = (state, { champion }) => ({
    ...state,
    selectedChampion: champion,
  });

  function makeReducer(serverData) {
    const initialState = {
      champions: serverData.champions,
      queryChampions: serverData.query_champions,
      recommendations: serverData.recommendations,
      selectedChampion: null,
    };

    return function reducer(state = initialState, action) {
      const handler = Handlers[action.type];
      if (handler) {
        return handler(state, action);
      } else {
        return state;
      }
    }
  }

  /*** Components ***/

  class DefaultChampionItem extends Component {
    render() {
      const { invert, i } = this.props;
      let className = 'sidebar-champ sidebar-champ--using-defaults';

      if (invert) {
        className += ' sidebar-champ--invert';
      }

      return (
        <div className={className}>
          <div className="sidebar-champ__image">
            <img src={DEFAULT_CHAMP_IMAGE_URL} alt="No champion selected" />
          </div>
          <div className="sidebar-champ__text">
            <div className="sidebar-champ__name">Champion {i}</div>
          </div>
        </div>
      );
    }
  }

  @connect()
  class RemovableChampion extends Component {
    static propTypes = {
      removeChampion: PropTypes.func,
    }

    removeChampion = (e) => {
      e.preventDefault();
      this.props.removeChampion(this.props.item);
    }

    render() {
      const { i, item: champion } = this.props;
      const { name, image_url } = champion;

      if (!name) {
        return <DefaultChampionItem i={i} />;
      }

      var hidden_style = {visibility: 'hidden'};

      return (
        <div className="sidebar-champ">
          <div className="sidebar-champ__image">
            <img src={image_url} alt={name} />
          </div>
          <div className="sidebar-champ__text">
            <a className="sidebar-champ__remove" href="" style={hidden_style}> x </a>
            <div className="sidebar-champ__name">{name}</div>
            <a className="sidebar-champ__remove" onClick={this.removeChampion} href="" key={name}>
              ×
            </a>
          </div>
        </div>
      );
    }
  }

  @connect()
  class RecommendedChampion extends Component {
    selectHovering = () => {
      if (this.championHovering) {
        this.props.dispatch(
          Actions.selectChampion(this.championHovering)
        );
      }
    }

    hovering = (champion) => {
      this.championHovering = champion;
      this.timeout = setTimeout(() => this.selectHovering(), 400);
    }

    leaving = (champion) => {
      this.championHovering = null;
      clearTimeout(this.timeout);
    }

    render() {
      const { i, item, selected } = this.props;
      const { role, recommendations } = item;
      const [ primary, ...secondary ] = recommendations;

      if (!primary) {
        return <DefaultChampionItem invert i={i} />;
      }

      const primarySelected = selected && primary.id === selected.id;

      return (
        <div className="sidebar-champ sidebar-champ--invert">
          <div className="sidebar-champ__mini-images">
            {secondary.map((champion) => {
              const championSelected = selected && champion.id === selected.id;
              return (
                <div className={'sidebar-champ__mini-image' + (championSelected ? ' sidebar-champ__mini-image--selected' : '')} key={champion.name} onMouseEnter={ e => this.hovering(champion)} onMouseLeave={e => this.leaving(champion)}>
                  <img src={champion.image_url} alt={champion.name} />
                  <div className="sidebar-champ__image-hover-effect sidebar-champ__image-hover-effect--mini" />
                </div>
              );
             })}
          </div>
          <div className={'sidebar-champ__image' + (primarySelected ? ' sidebar-champ__image--selected' : '')} onMouseEnter={e => this.hovering(primary)} onMouseLeave={e => this.leaving(primary)}>
            <img src={primary.image_url} alt={primary.name} />
            <div className="sidebar-champ__image-hover-effect" />
          </div>
          <div className="sidebar-champ__text">
            <div className="sidebar-champ__role">{role}</div>
            <div className="sidebar-champ__name">{primary.name}</div>
            <div className="sidebar-champ__role" style={{visibility: 'hidden'}}>{role}</div>
          </div>
        </div>
      );
    }
  }

  class ChampionSelectSidebar extends Component {
    render() {
      const { items, ItemComponent, itemProps, title } = this.props;

      return (
        <div className="champion-select-sidebar">
          <h2 className="champion-select-sidebar__title">
            {title}
          </h2>
          <div>
            {items.map((item, i) =>
              <ItemComponent key={i} {...itemProps} item={item} i={i} />
             )}
          </div>
        </div>
      );
    }
  }

  class PickableChampion extends Component {
    static propTypes = {
      pickChampion: PropTypes.func,
    }

    pickChampion = (e) => {
      e.preventDefault();
      if (!this.props.disabled) this.props.pickChampion(this.props.champion);
    }

    render() {
      const { champion, disabled } = this.props;
      let className = 'champion-picker__champion';

      if (disabled) {
        className += ' champion-picker__champion--picked';
      }

      return (
        <a className={className} onClick={this.pickChampion} href="">
          <div className="champion-picker__champion__image">
            <img src={champion.image_url} alt={champion.name} />
          </div>
          <div className="champion-picker__champion__name">
            {champion.name}
          </div>
        </a>
      );
    }
  }

  @connect(state => ({ selectedChampion: state.selectedChampion }))
  class ChampionPicker extends Component {
    state = {
      championFilter: '',
      menuShowing: true,
    }

    componentWillMount() {
      this.setPickedById(this.props.picked);
    }

    componentWillReceiveProps(nextProps) {
      if (this.props.picked !== nextProps.picked) {
        this.setPickedById(nextProps.picked);
      }

      if (nextProps.selectedChampion && this.props.selectedChampion !== nextProps.selectedChampion) {
        this.setState({ menuShowing: false });
      }
    }

    componentDidUpdate(prevProps, prevState) {
      if (this.state.menuShowing && !prevState.menuShowing) {
        setTimeout(
          () => this.props.dispatch(Actions.selectChampion(null)),
          400
        );
      }
    }

    setPickedById(picked) {
      this.pickedById = _.fromPairs(picked.map(c => [ c.id, true ]));
    }

    filteredChampions() {
      return this.props.champions.filter(c =>
        c.name.toLowerCase().indexOf(this.state.championFilter) === 0
      );
    }

    changeFilter = (e) => {
      this.setState({ championFilter: e.target.value });
    }

    pickChampion = (champion) => {
      this.props.dispatch(Actions.fetchRecommendations(
        this.props.picked.concat(champion)
      ));
    }

    toggleMenu = (e) => {
      e.preventDefault();
      e.target.blur();
      this.setState({ menuShowing: !this.state.menuShowing });
    }

    render() {
      const { menuShowing, championFilter } = this.state;
      const { picked, max, selectedChampion } = this.props;
      const champions = this.filteredChampions();

      let className = 'champion-picker';

      if (!menuShowing) {
        className += ' champion-picker--menu-hidden';
      }

      return (
        <div className={className}>
          <div className="champion-picker__menu">
            <a className="champion-picker__toggle" onClick={this.toggleMenu} href="">
              {menuShowing ? '▼' : '▲'}
            </a>

            <div className="champion-picker__top">
              <input
                autoFocus={picked.length < max}
                className="champion-picker__filter"
                value={championFilter}
                onChange={this.changeFilter}
                placeholder="Filter champions"
              />
            </div>

            <div className="champion-picker__champions-container">
              <div className="champion-picker__champions">
                {champions.map(champion =>
                  <PickableChampion
                    key={champion.id}
                    champion={champion}
                    disabled={picked.length >= max ? true : this.pickedById[champion.id]}
                    pickChampion={this.pickChampion}
                  />
                 )}
              </div>
            </div>
          </div>
          <div className="champion-picker__back-panel">
            {
              selectedChampion ?
              <h1 style={{ textAlign: 'center' }}>{selectedChampion.name}</h1> :
              null
            }
          </div>
        </div>
      );
    }
  }

  @connect(state => state)
  class ChampionRecommendations extends Component {
    removeChampion = (champion) => {
      this.props.dispatch(Actions.fetchRecommendations(
        this.props.queryChampions.filter(c => c.id !== champion.id),
      ));
    }

    render() {
      const {
        queryChampions,
        recommendations,
        champions,
        selectedChampion,
      } = this.props;

      return (
        <div className="champ-select-container">
          <div className="pane-layout">
            <div className="pane-layout__sidebar">
              <ChampionSelectSidebar
                title="Your champions"
                items={_.range(5).map(i => queryChampions[i] || {})}
                itemProps={{removeChampion: this.removeChampion}}
                ItemComponent={RemovableChampion}
              />
            </div>

            <div className="pane-layout__main">
              <ChampionPicker champions={champions} picked={queryChampions} max={5} />
            </div>

            <div className="pane-layout__sidebar">
              <ChampionSelectSidebar
                title="Recommendations"
                items={recommendationsByRole(recommendations)}
                itemProps={{selected: selectedChampion}}
                ItemComponent={RecommendedChampion}
              />
            </div>
          </div>
        </div>
      );
    }
  }

  class ChampionRecommendationsInitializer extends Component {
    componentWillMount() {
      const reducer = makeReducer(this.props);

      this.store = createStore(reducer, compose(
        applyMiddleware(LolCupid.asyncRequestMiddleware),
        window.devToolsExtension ? window.devToolsExtension() : f => f
      ));
    }

    render() {
      return (
        <Provider store={this.store}>
          <ChampionRecommendations />
        </Provider>
      );
    }
  }

  LolCupid.ChampionRecommendations = ChampionRecommendationsInitializer;

}();
