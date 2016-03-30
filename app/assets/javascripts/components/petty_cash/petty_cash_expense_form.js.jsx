var PettyCashExpenseForm = React.createClass({
    getInitialState: function(){
        return {concept: '',amount: '',expense_date: '',observation: '',petty_cash_id: this.props.petty_cash_id,error: []}
    },
    getDefaultProps: function(){
        return {notifyParent: function(){}}
    },
    inputChange: function(name,value){
        var inputResponse = {};
        inputResponse[name] = value;
        this.setState(inputResponse);
    },
    textAreaChange: function(e){
        this.setState({observation: e.target.value});
    },
    isValidExpense: function(){
        return this.state.concept && this.state.amount && this.state.expense_date
    },
    submitExpense: function(){
        if(parseInt(this.state.amount) <= 0){
            alert('Cantidad no puede ser menor a 0');
            return;
        }
        $.ajax({
            type: "POST",
            url: '/petty_cash_expenses',
            data: {petty_cash_expense: this.state},
            success: function(data){
                console.log(data);
                this.props.notifyParent(data);
                this.setState(this.getInitialState());
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
    render: function(){
       return (
           <div>
               <h4 className="text-center cons-inf-title">
                   <span className="text-muted">Agregar gasto </span>
               </h4>
                <ErrorBox errorsArray={this.state.errors}></ErrorBox>
               <LabelInput name="concept" label="Concepto" value={this.state.concept} changed={this.inputChange}/>
               <LabelInput name="amount" label="Cantidad" value={this.state.amount} addon="$" changed={this.inputChange} type="number"/>
               <DateInput name="expense_date" label="Fecha del gasto" changed={this.inputChange} value={this.state.expense_date} changed={this.inputChange}/>
               <label className="form-control">Observaciones o descripcion</label>
               <textarea className="form-control" value={this.state.observation} onChange={this.textAreaChange}/>
               <br/>
               <button className="btn btn-primary" disabled={!this.isValidExpense()} onClick={this.submitExpense}>Agregar</button>

           </div>);
    }
});