!function () {

  const { Component } = React;

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

  class Search extends Component {
    render() {
      return (
        <div className="centered-content">
          <h1>lolCupid</h1>
          <h4>Champion recommendations based on what you already love</h4>

          <div className="search">
            <div className="search__input-container">
              <input className="form-control search__input" placeholder="Search champion or summoner"/>
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
