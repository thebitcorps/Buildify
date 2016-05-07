/**
 * Props: <ul>
 *     <li> url: url to make the request of the search
 *     <li> queryParam: name of the param to include in the request of the search
 *     <li> searchDelay: millis to wait for the request to start when the user start typing
 *     <li> resultClearDelay: millis when the result list will disapear
 *     <li>  tokenAdded {function}: function that notify parent when a result is clicked,@param: value that was selected by user
 *     <li> tokenRemoved {function}: function that notify parent when a token is removed,@param: value that was removed by user
 *     <li> clean: this is for the parent can clean the token setting this to false or true for handling a token added or remove
 * </ul>
 */
var TokenInputCustom = React.createClass({
    getInitialState: function () {
        return {search: '',results: [],token: ''}
    },
    getDefaultProps: function () {
        var emptyFunction = function () {};
      return {url: '/',queryParam: 'search',searchDelay: 300,resultClearDelay: 4000,tokenAdded: emptyFunction,tokenRemoved: emptyFunction,clean: true}
    },
    componentWillUnmount: function() {
        this.abortSearchRequest();
    },

    searchChange: function (e) {
        var inputValue = e.target.value,search= {};
        this.setState({search: inputValue});
        search[this.props.queryParam] = inputValue;
        clearTimeout(this.requestTimeout);
        this.abortSearchRequest();
        this.requestTimeout = setTimeout(()=> this.getSearchRequest(search),this.props.searchDelay);
    },
    abortSearchRequest: function () {
        if(this.ajaxRequest){
            this.ajaxRequest.abort();
        }
    },
    getSearchRequest: function (search) {
        this.ajaxRequest = $.ajax({
            type: "GET",
            url: this.props.url,
            data: search,
            success: function(data){
                this.setState({results: data});
                clearTimeout(this.resultTimeout);
                this.resultTimeout = setTimeout(function () {this.setState({results: []})}.bind(this),this.props.resultClearDelay);
            }.bind(this),
            error: function(XMLHttpRequest, textStatus, errorThrown){
                if(errorThrown == 'Internal Server Error'){
                    this.setState({ errors: ['Internal Server Error']});
                    return;
                }
                this.setState({ errors: $.parseJSON(XMLHttpRequest.responseText)});
            }.bind(this),
            dataType: 'JSON'
        });
    },
    onRemoveToken: function () {
        this.props.tokenRemoved();
        this.setState(this.getInitialState())
    },
    onResultClick: function (resultClick) {
        this.props.tokenAdded(resultClick);
        this.setState({results: [],token: resultClick.name})

    },
    // TODO will recive props clean search state
    render: function () {
        var token;
        //props.clean is a props for the parent to clean the token input
        if(this.state.token == 0 || this.props.clean){
            token = <input type="text" name="search" value={this.state.search} onChange={this.searchChange} className="form-control" autoComplete="off"/>;
        }else {
            token = <span className="tag label label-primary">
                      <span>{this.state.token}</span>
                      <a onClick={this.onRemoveToken}><i className="remove glyphicon glyphicon-remove-sign glyphicon-white"/></a>
                    </span>;
        }
        var results = this.state.results.map(function (result) {
            return (<div className=" hover list-group-item " style={{cursor: 'pointer'}} key={result.id} onClick={()=>this.onResultClick(result)}><h6 className="list-group-item-heading">{result.name + ' '+ result.description}</h6></div>);
        }.bind(this));

        return (
          <div>
              <div className="row">{token}</div>
              <div className="list-group" style={{ position: 'absolute', zIndex: 99999 }}>
                  {results}
              </div>
          </div>
        );
    }
});