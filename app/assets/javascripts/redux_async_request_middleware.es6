!function () {

  const { createStore, applyMiddleware } = Redux;

  function asyncRequestMiddleware() {
    return (dispatch) => (action) => {
      let { promise, types, ...actionData } = action;

      if (!promise) {
        return dispatch(action);
      }

      if (_.has(actionData, 'type') || _.has(actionData, 'result') || _.has(actionData, 'error')) {
        throw `Async request action cannot have keys 'type', 'result', or 'error'`;
      }

      const [REQUEST, SUCCESS, FAILURE] = types;

      dispatch({type: REQUEST, ...actionData});

      return promise().then(
        result => dispatch({type: SUCCESS, result, ...actionData}),
        error  => dispatch({type: FAILURE, error,  ...actionData})
      );
    };
  }

  LolCupid.asyncRequestMiddleware = asyncRequestMiddleware;

}();
