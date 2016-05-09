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
      summoner: serverData.summoner
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
            <div className="sidebar-champ__name">Champion {i+1}</div>
          </div>
        </div>
      );
    }
  }

  @connect()
  class NonremovableChampion extends Component {
    static propTypes = {
      removeChampion: PropTypes.func,
    }

    render() {
      const { i, item: champion } = this.props;
      const { name, image_url } = champion;

      if (!name) {
        return <DefaultChampionItem i={i} />;
      }

      return (
        <div className="sidebar-champ">
          <div className="sidebar-champ__image">
            <img src={image_url} alt={name} />
          </div>
          <div className="sidebar-champ__text">
            <div className="sidebar-champ__name">{name}</div>
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

      return (
        <div className="sidebar-champ sidebar-champ--removable" onClick={this.removeChampion}>
          <div className="sidebar-champ__image">
            <img src={image_url} alt={name} />
          </div>
          <div className="sidebar-champ__text">
            <a className="sidebar-champ__remove" href="" style={{visibility: 'hidden'}}> x </a>
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
            {items.map((item, i) => <ItemComponent key={i} {...itemProps} item={item} i={i} /> )}
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

  const SPELL_MAPPING = ['Passive', 'Q', 'W', 'E', 'R'];

  class ChampionOverview extends Component {
    state = {
      selectedSpell: 0,
    };

    getChampionGGUrl = (champName) => {
      var ret = champName.replace(/ /g, "");
      ret = ret.replace(/'/g, "");
      return "http://champion.gg/champion/"+ret;
    };

    getProBuildsUrl = (champName) => {
      var ret = champName;
      if (champName == "Jarvan IV") {
        ret = "JarvanIV";
      } else {
        while (ret.indexOf("'") != -1) {
          var idx = ret.indexOf("'");
          ret = ret.substr(0,idx) + ret[idx+1].toLowerCase() + ret.substr(idx+2);
        }
        ret = ret.replace(/ /g, "");
      }
      return "http://www.probuilds.net/champions/details/"+ret;
    };

    componentWillReceiveProps(nextProps) {
      if (this.props.champion !== nextProps.champion) {
        this.setState({ selectedSpell: 0 });
      }
    }

    selectSpell = (index) => {
      this.setState({ selectedSpell: index });
    }

    renderSpell = (spell, i) => {
      const { selectedSpell } = this.state;
      let className = 'champion-overview__spells__bar__spell';

      if (i === selectedSpell) {
        className += ' champion-overview__spells__bar__spell--selected';
      }

      return (
        <div
          key={spell.name}
          className={className}
          onMouseEnter={e => this.selectSpell(i)}
        >
          <img src={spell.image_url} alt={spell.name} />
        </div>
      );
    }

    renderSelectedSpell() {
      const { selectedSpell } = this.state;
      const { champion } = this.props;
      const spell = champion.spells[selectedSpell];

      return (
        <div className="spell-overview">
          <div>
            <span className="spell-overview__key">
              {SPELL_MAPPING[selectedSpell]}
            </span>

            <span className="spell-overview__name">
              {spell.name}
            </span>
          </div>

          <div className="spell-overview__description">
            {spell.description}
          </div>
        </div>
      );
    }

    render() {
      const { champion } = this.props;

      return (
        <div className="champion-overview">
          <div className="champion-overview__header">
            <h1 className="champion-overview__name">{champion.name}</h1>
            <div className="champion-overview__links">
              <a href={this.getProBuildsUrl(champion.name)} target="_blank">
                on ProBuilds.net
              </a>
              <a href={this.getChampionGGUrl(champion.name)} target="_blank">
                on Champion.gg
              </a>
            </div>
          </div>

          <div className="champion-overview__splash">
            <img src={champion.splash_url} alt={champion.name} data-champion={champion.name} />
          </div>
          <div className="champion-overview__spells">
            <div className="champion-overview__spells__bar">
              {champion.spells.map(this.renderSpell)}
            </div>
            {this.renderSelectedSpell()}
          </div>
        </div>
      );
    }
  }

  @connect(state => ({ selectedChampion: state.selectedChampion }))
  class ChampionPicker extends Component {
    state = {
      championFilter: '',
      menuShowing: this.props.picked.length < this.props.max,
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

      if (this.props.picked.length < nextProps.max && nextProps.picked.length === nextProps.max) {
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
      setTimeout(() => this.setState({ championFilter: '' }), 100);
    }

    toggleMenu = (e) => {
      e.preventDefault();
      e.target.blur();
      this.setState({ menuShowing: !this.state.menuShowing });
    }

    renderPicker = () => {
      const { summonerPresent, picked, max, selectedChampion } = this.props;
      const { menuShowing, championFilter } = this.state;
      const champions = this.filteredChampions();

      return (
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
      );
    }

    renderOverview = () => {
      const { summonerPresent, picked, max, selectedChampion } = this.props;
      return (
        <div className="champion-picker__back-panel">
          {
            selectedChampion ?
            <ChampionOverview champion={selectedChampion} /> :
            <div style={{width:'50%', margin:'4rem auto', textAlign:'center', fontSize:'1.3em'}}>
              Hover over a recommendation on the right to show details about the champion.
            </div>
          }
        </div>
      );
    }

    render() {
      const { summonerPresent, picked, max, selectedChampion } = this.props;
      const { menuShowing, championFilter } = this.state;

      let className = 'champion-picker';

      if (!summonerPresent && !menuShowing) {
        className += ' champion-picker--menu-hidden';
      }

      if (summonerPresent) {
        className += ' champion-picker--hide-border';
      }

      return (
        <div className={className}>
          {summonerPresent ? null : this.renderPicker()}
          {this.renderOverview()}
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

    rankedInfo = (summoner) => {
      if (summoner.tier) {
        if (summoner.tier == 'master') {
          return 'Master';
        } else if (summoner.tier == 'challenger') {
          return 'Challenger';
        } else {
          return summoner.tier[0].toUpperCase() + summoner.tier.substr(1) + ' ' + summoner.division.toUpperCase();
        }
      } else {
        return 'Level ' + summoner.summoner_level;
      }
    }

    renderSummonerOverview = (summoner) => {
      return (
        <div className="summoner-overview">
          <img className="summoner-overview__icon" src={summoner.profile_icon_url} />
          <div className="summoner-overview__text">
            <span className="summoner-overview__name">
              {summoner.display_name}
            </span>
            <span className="summoner-overview__rank">
              {this.rankedInfo(summoner)}
            </span>
          </div>
        </div>
      );
    }

    render() {
      const {
        queryChampions,
        recommendations,
        champions,
        selectedChampion,
        summoner
      } = this.props;

      var summonerPresent = !!summoner;

      return (
        <div className="champ-select-container">
          {summoner? this.renderSummonerOverview(summoner) : null}
          <div className="pane-layout">
            <div className="pane-layout__sidebar">
              {
                summonerPresent ?
                <ChampionSelectSidebar
                  title="Your champions"
                  items={_.range(5).map(i => queryChampions[i] || {})}
                  ItemComponent={NonremovableChampion}
                /> :
                <ChampionSelectSidebar
                  title="Your champions"
                  items={_.range(5).map(i => queryChampions[i] || {})}
                  itemProps={{removeChampion: this.removeChampion}}
                  ItemComponent={RemovableChampion}
                />
              }
            </div>

            <div className="pane-layout__main">
              <ChampionPicker
                summonerPresent={summonerPresent}
                champions={champions}
                picked={queryChampions}
                max={5}
              />
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
