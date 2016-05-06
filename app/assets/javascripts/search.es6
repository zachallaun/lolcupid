!function () {

  const { Component, PropTypes } = React;

  const REGIONS = ['br', 'eune', 'euw', 'jp', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr'];

  const KEY_CODES = {
    up: 38,
    down: 40,
    enter: 13
  };

  class RegionSelector extends Component {
    state = {
      dropdown: false,
      selected: 'na',
    };

    openDropdown  = () => this.setState({ dropdown: true });
    closeDropdown = () => this.setState({ dropdown: false });

    selectRegion(e, region) {
      e.preventDefault();
      this.setState({ selected: region, dropdown: false }, this.props.alertParent(region));
    }

    renderMenuOptions() {
      return REGIONS.map(region =>
        <li key={region}>
          <a href="" onClick={e => this.selectRegion(e, region)}>
            {region}
          </a>
        </li>
      );
    }

    render() {
      return (
        <div
          className="region-selector"
          onMouseEnter={this.openDropdown}
          onMouseLeave={this.closeDropdown}
        >
          <button className="region-selector__button" onFocus={this.openDropdown}>
            {this.state.selected}
          </button>
          {
            this.state.dropdown ?
            <ul className="region-selector__menu">
              {this.renderMenuOptions()}
            </ul> :
            null
          }
        </div>
      );
    }
  }

  function championNameMatchParts(query, champion) {
    const matchEndIndex = champion.matchAt + query.length;

    const firstPart = champion.name.slice(0, champion.matchAt);
    const matchPart = champion.name.slice(champion.matchAt, matchEndIndex);
    const lastPart = champion.name.slice(matchEndIndex);

    return [ firstPart, matchPart, lastPart ];
  }

  class ChampionSelector extends Component {
    state = {
      query: '',
      results: [],
      selected: null,
    };

    selectedChanged = () => {
      if (this.state.selected == null) {
        this.props.alertParent('', true);
      } else if (this.state.results[this.state.selected].querySummoner) {
        this.props.alertParent(this.state.query, true);
      } else {
        this.props.alertParent(this.state.results[this.state.selected].name, false);
      }
    }

    componentDidUpdate(_prevProps, prevState) {
      if (prevState.query !== this.state.query) {
        let results = [];

        if (this.state.query.trim() !== '') {
          results = _(this.props.champions.reduce((results, champion) => {
            const matchAt = champion.name.toLowerCase().indexOf(this.state.query.toLowerCase());

            if (matchAt !== -1) {
              results.push({ ...champion, matchAt });
            }

            return results;
          }, [])).sortBy('matchAt').take(6).value();
        }

        if (results.length > 0) {
          this.setState({ results: results.concat({ querySummoner: true }), selected: 0 });
        } else if (this.state.query.trim() !== '') {
          this.setState({ results: results.concat({ querySummoner: true }), selected: 0 });
        } else {
          this.setState({ results: [], selected: null });
        }
      }
    }

    updateQuery = (e) => {
      this.setState({ query: e.target.value }, this.selectedChanged);
    }

    handleKeyDown = (e) => {
      if (e.keyCode === KEY_CODES.down) {
        e.preventDefault();
        let new_select;
        if (this.state.selected + 1 >= this.state.results.length) {
          new_select = 0;
          // this.setState({ selected: 0 });
        } else {
          new_select = this.state.selected + 1;
          // this.setState({ selected: this.state.selected + 1 });
        }
        this.setState({ selected: new_select }, this.selectedChanged);
      } else if (e.keyCode === KEY_CODES.up) {
        e.preventDefault();
        let new_select;
        if (this.state.selected - 1 < 0) {
          new_select = this.state.results.length - 1;
          // this.setState({ selected: this.state.results.length - 1 });
        } else {
          new_select = this.state.selected - 1;
          // this.setState({ selected: this.state.selected - 1 });
        }
        this.setState({ selected: new_select }, this.selectedChanged);
      } else if (e.keyCode === KEY_CODES.enter) {
        this.props.commenceSearch();
      }
    }

    renderResult = (result, index) => {
      const { query, selected } = this.state;

      let content;

      if (result.querySummoner) {
        content = (
          <div className="champion-option__content">
            <div className="champion-option__text">
              <span className="champion-option__title champion-option__title">
                Search for summoner '{this.state.query}'
              </span>
            </div>
          </div>
        );
      } else {
        const [ firstPart, matchPart, lastPart ] = championNameMatchParts(query, result);

        content = (
          <div className="champion-option__content">
            <img
              className="champion-option__portrait"
              src={result.image_url}
              alt={result.name}
            />
            <div className="champion-option__text">
              <span className="champion-option__name">
                {firstPart}
                <span className="champion-option__highlighted">{matchPart}</span>
                {lastPart}
                &nbsp;
              </span>
              <span className="champion-option__title">
                {result.display_title}
              </span>
            </div>
          </div>
        );
      }

      let championOptionClass = 'champion-option';
      if (result.querySummoner) championOptionClass += ' champion-option--is-query-summoner';
      if (index === selected)   championOptionClass += ' champion-option--is-selected';

      return (
        <li key={result.querySummoner ? 'query-summoner' : result.id}>
          <a
            className={championOptionClass}
            // href=""
            onMouseEnter={e => this.setState({ selected: index }, this.selectedChanged)}
            onClick={this.props.commenceSearch}
          >
            {content}
          </a>
        </li>
      );
    }

    renderResults() {
      if (this.state.query.trim() === '') {
        return null;
      }

      return (
        <ul className="champion-selector__menu">
          {this.state.results.map(this.renderResult)}
        </ul>
      );
    }

    render() {
      const { query } = this.state;

      return (
        <div className="champion-selector">
          <input
            className="form-control champion-selector__input"
            autoFocus
            value={query}
            onKeyDown={this.handleKeyDown}
            onChange={this.updateQuery}
            placeholder="Search champion or summoner"
          />
          {this.renderResults()}
        </div>
      );
    }
  }

  class Search extends Component {
    state = {
      selected: '',
      isSummoner: true,
      region: 'na'
    };

    static propTypes = {
      champions: PropTypes.arrayOf(PropTypes.object).isRequired,
    };

    regionChanged = (region) => {
        this.setState({region: region});
    }

    selectedChanged = (selected, isSummoner) => {
      if (selected == '') {
        this.setState({selected: '', isSummoner: true});
      } else {
        this.setState({selected: selected, isSummoner: isSummoner});
      }
    }

    commenceSearch = () => {
      if (this.state.selected != '' && this.state.isSummoner) {
        window.location.href = "/summoner?region="+this.state.region+"&name="+this.state.selected;
      } else if (this.state.selected != '' && !this.state.isSummoner) {
        window.location.href = "/champions?name="+this.state.selected;
      }
    }

    render() {
      return (
        <div className="search">
          <div className="search__input-container">
            <ChampionSelector champions={this.props.champions} alertParent={this.selectedChanged} commenceSearch={this.commenceSearch} />
            <div className="search__region-selector">
              <RegionSelector defaultRegion='na' alertParent={this.regionChanged} />
            </div>
          </div>
          <button className="btn btn-primary" onClick={this.commenceSearch}>Search</button>
        </div>
      );
    }
  }

  LolCupid.Search = Search;

}();
