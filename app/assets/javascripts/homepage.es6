!function() {

  const { Component, PropTypes } = React;

  class Homepage extends Component {
    render() {
      return (
        <div className="homepage-content zoom">
          <h1 className="logo-header">
            <span className="logo-header__prefix">LoL</span>
            <span className="logo-header__suffix">Cupid</span>
          </h1>
          <h4 className="homepage-content__subheader">
            Champion Matchmakers
          </h4>
          <LolCupid.Search champions={this.props.champions} />
        </div>
      );
    }
  }

  LolCupid.Homepage = Homepage;

}();
