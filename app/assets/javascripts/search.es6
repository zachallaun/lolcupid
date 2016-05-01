!function () {

  const { Component, PropTypes } = React;

  const REGIONS = ['br', 'eune', 'euw', 'jp', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr'];

  class RegionSelector extends Component {
    state = {
      dropdown: false,
      selected: 'na',
    };

    openDropdown  = () => this.setState({ dropdown: true });
    closeDropdown = () => this.setState({ dropdown: false });

    selectRegion(e, region) {
      e.preventDefault();
      this.setState({ selected: region, dropdown: false });
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

  class ChampionSelector extends Component {
    state = {
      query: '',
      results: [],
      selected: null,
    };

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
          }, [])).sortBy('matchAt').take(8).value();
        }

        if (results.length > 0) {
          this.setState({ results, selected: 0 });
        } else {
          this.setState({ results, selected: null });
        }
      }
    }

    updateQuery = (e) => this.setState({ query: e.target.value });

    renderResult = (result) => {
      const { query, selected } = this.state;

      return (
        <li key={ result.id }>
          <a href="">{ result.name }</a>
        </li>
      );
    }

    renderResults() {
      if (this.state.results.length === 0) {
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
            value={query}
            onChange={this.updateQuery}
            placeholder="Search champion or summoner"
          />
          {this.renderResults()}
        </div>
      );
    }
  }

  class Search extends Component {
    static propTypes = {
      champions: PropTypes.arrayOf(PropTypes.object).isRequired,
    };

    render() {
      return (
        <div className="centered-content">
          <h1>lolCupid</h1>
          <h4>Champion recommendations based on what you already love</h4>

          <div className="search">
            <div className="search__input-container">
              <ChampionSelector champions={this.props.champions} />
              <div className="search__region-selector">
                <RegionSelector />
              </div>
            </div>
            <button className="btn btn-primary">Search</button>
          </div>
        </div>
      );
    }
  }

  LolCupid.Search = Search;

}();
