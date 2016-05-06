!function() {

  const { Component, PropTypes } = React;
  const { createStore, compose, applyMiddleware } = Redux;
  const { Provider, connect } = ReactRedux;

  const DEFAULT_CHAMP_IMAGE_URL = 'https://ddragon.leagueoflegends.com/cdn/6.9.1/img/profileicon/16.png';

  /*** Action helpers ***/

  const API = {
    recommendations: {
      show: (queryString) => {
        return fetch('/api/recommendations' + queryString).then(r => r.json());
      },
    },
  };

  function championsToQueryString(champions) {
    const championNames = champions.map(c => c.name.replace(' ', '_')).join(',');
    return `?name=${championNames}`;
  }

  /*** Actions ***/

  let Actions = {};

  Actions.fetchRecommendations = (champions) => {
    // TODO handle case where champions is empty
    // TODO change route query params
    return {
      types: [
        'fetchRecommendations',
        'fetchRecommendationsSuccess',
        'fetchRecommendationsFailure',
      ],
      promise: () => API.recommendations.show(
        championsToQueryString(champions)
      ),
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

  class ChampionSelectSidebar extends Component {
    static propTypes = {
      invert: PropTypes.bool,
      removeChampion: PropTypes.func,
    }

    static defaultProps = {
      champions: [],
    }

    removeChampion = (e, champion) => {
      e.preventDefault();
      this.props.removeChampion(champion);
    }

    renderChampion(champion = {}, i) {
      let { name, image_url } = champion;
      let className = 'sidebar-champ';

      if (!name) {
        className += ' sidebar-champ--using-defaults';
        name = `Champion ${i}`;
        image_url = DEFAULT_CHAMP_IMAGE_URL;
      }

      if (this.props.invert) {
        className += ' sidebar-champ--invert';
      }

      return (
        <div className={className} key={name || i}>
          <div className="sidebar-champ__image">
            <img src={image_url} alt={name} />
          </div>
          <div className="sidebar-champ__text">
            <div className="sidebar-champ__name">{name}</div>
          </div>
          {
            this.props.removeChampion ?
            <a href="" onClick={e => this.removeChampion(e, champion)}>
              x
            </a> :
            null
          }
        </div>
      );
    }

    render() {
      const { champions } = this.props;

      return (
        <div className="champ-select-sidebar">
          {_.times(5).map(i => this.renderChampion(champions[i], i+1))}
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
                champions={queryChampions}
                removeChampion={this.removeChampion}
              />
            </div>

            <div className="pane-layout__main">
              main
            </div>

            <div className="pane-layout__sidebar">
              <ChampionSelectSidebar
                invert
                champions={_.take(recommendations, 5)}
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
