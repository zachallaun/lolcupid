!function() {

  const { Component, PropTypes } = React;


  class Championpage extends Component {
    render_rec_panel(name, score) {
      return (
        <div className="recommendation-panel">
          <div className="recommendation-panel__portrait"> </div>
          <div className="recommendation-panel__name"> {name} </div>
          <div className="recommendation-panel__score"> {score.toPrecision(2)} </div>
        </div>
      );
    }

    render_recs_for_role(role_name, role_rec_list) {
      return (
        <div>
            <h4> {role_name} </h4>
            <div className="recommendation-container">
              {role_rec_list.map(rec => this.render_rec_panel(rec[0], rec[1]))}
            </div>
        </div>
      );
    }

    render() {
      return (
        <div className="aboutpage-content">
            <h1 className="aboutpage-content__header">
                Recommendations
            </h1>
            {this.render_recs_for_role("Top", this.props.recs_top)}
            {this.render_recs_for_role("Jungle", this.props.recs_jungle)}
            {this.render_recs_for_role("Middle", this.props.recs_middle)}
            {this.render_recs_for_role("Bottom Carry", this.props.recs_bottom_carry)}
            {this.render_recs_for_role("Bottom Support", this.props.recs_bottom_support)}
        </div>
      );
    }
  }

  LolCupid.Championpage = Championpage;

}();
