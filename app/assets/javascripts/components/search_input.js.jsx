/**
 * Input for handling SCRIPT response, will use props.url and send the value that the input has and send it in props.queryParam as param
 * Props:
 * <ul>
 *     <li>queryParam: {default: search},this is the name of the params to append to the request
 *     <li>url {default /},this is the url the input will send the GET request
 *     <li>searhcDelay: {default: 300} millis to start the request after user finish typing
 *     <li>placeholder: {defalt: search} placeholder for the search input
 */
var SearchInput = React.createClass({
    propTypes: {
        queryParam: React.PropTypes.string,
        url: React.PropTypes.string.isRequired,
        searchDelay: React.PropTypes.number,
        placeholder: React.PropTypes.string
    },
    getDefaultProps: function () {
      return {queryParam: 'search',searchDelay: 300,placeholder: 'search', staticParams: {}}
    },
    getInitialState: function () {
        return {searching: false}
    },
    inputChange: function (name,value) {
        var inputValue = {};
        inputValue[name] = value;
        this.setState({inputValue,searching:true});
        //clear previews request
        clearTimeout(this.requestTimeout);
        this.requestTimeout = setTimeout(()=> this.getSearchRequest(inputValue),this.props.searchDelay);
    },
    searchButtonClick: function () {
        var value = {};
        value[this.props.queryParam] = this.state[this.props.queryParam];
        this.setState({searching: true});
        this.getSearchRequest(value);
    },
    /**
     * Overwrites obj1's values with obj2's and adds obj2's if non existent in obj1
     * @param obj1
     * @param obj2
     * @returns obj3 a new object based on obj1 and obj2
     */
    mergeOptions: function (obj1, obj2){
        var obj3 = {};
        for (var attrname in obj1) { obj3[attrname] = obj1[attrname]; }
        for (var attrname in obj2) { obj3[attrname] = obj2[attrname]; }
        return obj3;
    },
    getSearchRequest: function (search) {
        this.abortSearchRequest();
        this.ajaxRequest = $.ajax({
                        type: "GET",
                        url: this.props.url,
                        data: this.mergeOptions(search, this.props.staticParams),
                        dataType: 'SCRIPT',
                        success: function(data){
                            eval(data);
                            clearTimeout(this.resultTimeout);
                            this.setState({searching: false});
                        }.bind(this),
                        error: function(XMLHttpRequest, textStatus, errorThrown){
                            alert(XMLHttpRequest.responseText);
                            this.setState({searching: false});
                        }.bind(this)
                });

    },
    abortSearchRequest: function () {
        if(this.ajaxRequest){
                this.ajaxRequest.abort();
            }
    },
    render: function () {
        var spinner = null;
        if(this.state.searching){
            spinner = <i className="fa fa-circle-o-notch  text-primary fa-spin" style={{'fontSize':'24px'}}/>;

        }
        return (
            <div className="search-input form-inline">
                {spinner}
                <LabelInput name={this.props.queryParam} changed={this.inputChange} placeholder={this.props.placeholder}/>
                <button className="btn btn-primary" onClick={this.searchButtonClick}>Search</button>
            </div>
        )
    }

});