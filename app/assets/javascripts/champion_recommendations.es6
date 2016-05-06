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

  function makeReducer(serverData) {
    const initialState = {
      champions: serverData.champions,
      queryChampions: serverData.query_champions,
      recommendations: serverData.recommendations,
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

      return (
        <div className="sidebar-champ">
          <div className="sidebar-champ__image">
            <img src={image_url} alt={name} />
          </div>
          <div className="sidebar-champ__text">
            <div className="sidebar-champ__name">{name}</div>
          </div>
          <a className="sidebar-champ__remove" onClick={this.removeChampion} href="" key={name}>
            ×
          </a>
        </div>
      );
    }
  }

  class RecommendedChampion extends Component {
    render() {
      const { i, item } = this.props;
      const { role, recommendations } = item;
      const [ primary, ...secondary ] = recommendations;

      if (!primary) {
        return <DefaultChampionItem invert i={i} />;
      }

      return (
        <div className="sidebar-champ sidebar-champ--invert">
          <div className="sidebar-champ__mini-images">
            {secondary.map(({ name, image_url }) =>
              <div>
                <img src={image_url} alt={name} />
              </div>
             )}
          </div>
          <div className="sidebar-champ__image">
            <img src={primary.image_url} alt={primary.name} />
          </div>
          <div className="sidebar-champ__text">
            <div className="sidebar-champ__role">{role}</div>
            <div className="sidebar-champ__name">{primary.name}</div>
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

  @connect()
  class ChampionPicker extends Component {
    componentWillMount() {
      this.setPickedById(this.props.picked);
    }

    componentWillReceiveProps(nextProps) {
      if (this.props.picked !== nextProps.picked) {
        this.setPickedById(nextProps.picked);
      }
    }

    setPickedById(picked) {
      this.pickedById = _.fromPairs(picked.map(c => [c.id, true]));
    }

    pickChampion = (champion) => {
      this.props.dispatch(Actions.fetchRecommendations(
        this.props.picked.concat(champion)
      ));
    }

    render() {
      const { champions, picked, max } = this.props;

      return (
        <div className="champion-picker">
          <div className="champion-picker__top">
          </div>

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
      const { queryChampions, recommendations, champions } = this.props;

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
                ItemComponent={RecommendedChampion}
              />
            </div>
          </div>
        </div>
      );
    }
  }

  class Championpage extends Component {
    render_rec_panel({ name, score, image_url }) {
      return (
        <div className="recommendation-panel">
          <img className="recommendation-panel__portrait" src={image_url} />
          <div className="recommendation-panel__name"> {name} </div>
          <div className="recommendation-panel__score"> {score.toPrecision(2)} </div>
        </div>
      );
    }

    render_recs_for_role(role_name, champs) {
      return (
        <div>
            <h4> {role_name} </h4>
            <div className="recommendation-container">
              {_.take(champs, 10).map(champ => this.render_rec_panel(champ))}
            </div>
        </div>
      );
    }

    render() {
      const recs_top = _.filter(this.props.recommended_champions, 'can_top');
      const recs_jungle = _.filter(this.props.recommended_champions, 'can_jungle');
      const recs_mid = _.filter(this.props.recommended_champions, 'can_mid');
      const recs_bot_carry = _.filter(this.props.recommended_champions, 'can_bot_carry');
      const recs_bot_support = _.filter(this.props.recommended_champions, 'can_bot_support');

      return (
        <div className="aboutpage-content">
            <h1 className="aboutpage-content__header">
                Recommendations
            </h1>
            {this.render_recs_for_role("Top", recs_top)}
            {this.render_recs_for_role("Jungle", recs_jungle)}
            {this.render_recs_for_role("Middle", recs_mid)}
            {this.render_recs_for_role("Bottom Carry", recs_bot_carry)}
            {this.render_recs_for_role("Bottom Support", recs_bot_support)}
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
