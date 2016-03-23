//"material"=>{"name"=>"Cal", "description"=>"Calidra", "measure_unit_ids"=>["4", "5", ""]},
var MaterialModal = React.createClass({
    inputChange: function(name,value){
        var inputResponse = {};
        inputResponse[name] = value;
        this.setState(inputResponse);
    },
    getInitialState: function(){
        return {units: [],measure_unit_ids: [],errors: []};
    },
    getDefaultProps: function(){
      return {name: ''};
    },
    componentDidMount: function(){
        this.serverRequest = $.get('/measure_units', function (result) {
            this.setState({units: result});
        }.bind(this),'json');
    },
    componentWillUnmount: function() {
        this.serverRequest.abort();
    },
    checkboxChange: function(name,value){
        var units = this.state.measure_unit_ids.slice();
        if(value){
            units.push(name);
        }else{
            var index  = this.state.measure_unit_ids.indexOf();
            units.splice(index,1);
        }
        this.setState({measure_unit_ids: units});

    },
    validMaterial: function(){
      return this.state.name && this.state.measure_unit_ids.length > 0
    },
    submitMaterial: function(){
        $.ajax({
            type: "POST",
            url: '/materials',
            data: {material: {name: this.state.name,measure_unit_ids: this.state.measure_unit_ids}},
            success: function(data){
                $('#material-modal').modal('hide');
            },
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

    render: function(){
        var units = this.state.units.map(function(item){
            return  <CheckboxInput name={item.id} changed={this.checkboxChange} label={item.unit} key={item.id}/>
        }.bind(this));
        var submit = <button onClick={this.submitMaterial} className="btn btn-primary" disabled={!this.validMaterial()}>Agregar</button>;
        //console.log(units);
        return (
            <div>
                <Modal title="Proponer Nuevo Material" parentNode="new-material" size="md" footer={submit} name="material-modal">
                    <div>

                        <ErrorBox errorsArray={this.state.errors}/>
                        <LabelInput  name="name" label="Nombre del nuevo material" changed={this.inputChange} value={this.state.name} />
                        <label>Unidades permitidas </label>
                        <br/>
                        {units}
                        <br/>

                    </div>
                </Modal>
            </div>
        );
    }
});