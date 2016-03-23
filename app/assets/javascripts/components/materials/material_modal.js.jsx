var MaterialModal = React.createClass({
    inputChange: function(name,value){
        var inputResponse = {};
        inputResponse[name] = value;
        this.setState(inputResponse);
    },
    getInitialState: function(){
        this.units = [];
        return {name: '',units: []};
    },
    componentDidMount: function(){
        this.serverRequest = $.get('/measure_units', function (result) {
            this.setState({units: result});
        }.bind(this),'json');
    },
    componentWillUnmount: function() {
        this.serverRequest.abort();
    },
    render: function(){
        var units = this.state.units.map(function(item){
            return "<LabelRadio name={item.id} value='authorized'  label='Por llegar' changed{radioChanged} />"
        });
        //console.log(units);
        return (
            <div>
                <Modal title="Proponer Nuevo Material" parentNode="new-material" size="md">
                    <div>
                        <LabelInput  name="name" label="Nombre del nuevo material" changed={this.inputChange} value={this.state.name} />
                        <label>Unidades permitidas </label>
                        {units}
                    </div>
                </Modal>
            </div>
        );
    }
});