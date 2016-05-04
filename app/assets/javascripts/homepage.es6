!function() {

  const { Component, PropTypes } = React;

  class Homepage extends Component {
    render() {
      return (
        <div className="homepage-content zoom">
          <h1 className="homepage-content__header">
            lolCupid
          </h1>
          <h4 className="homepage-content__subheader">
            Champion recommendations based on what you already love
          </h4>
          <LolCupid.Search champions={this.props.champions} />
        </div>
      );
    }
  }

  LolCupid.Homepage = Homepage;

}();
