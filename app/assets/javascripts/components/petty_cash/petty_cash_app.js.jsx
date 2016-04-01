var PettyCashApp = React.createClass({

    getInitialState: function(){
      return {petty_cash_expenses: this.props.petty_cash_expenses,errors: []}
    },
    addNewExpense: function(expense){
        var expenses = this.state.petty_cash_expenses.slice();
        expenses.unshift(expense);
        this.setState({petty_cash_expenses: expenses});
    },
    closePettyCash: function(){
        var response = confirm("Desea hacer el corte de la caja chica?");
        if(!response){
            return;
        }
        $.ajax({
            type: "PATCH",
            url: '/petty_cashes/'+ this.props.petty_cash.id,
            dataType: 'JSON',
            data: {petty_cash: {closing_date: moment().format()}},
            success: function(data){
                $.ajax({
                    type: "POST",
                    url: '/petty_cashes',
                    dataType: 'JSON',
                    data: {petty_cash: {construction_id: this.props.petty_cash.construction_id,amount: '1000'}},
                    success: function(data){
                        location.replace("/petty_cashes/"+data.id);
                    }.bind(this),
                    error: function(XMLHttpRequest, textStatus, errorThrown){
                        if(errorThrown == 'Internal Server Error'){
                            this.setState({ errors: ['Internal Server Error']});
                            return;
                        }
                        this.setState({ errors: $.parseJSON(XMLHttpRequest.responseText)});
                    }.bind(this)

                });
            }.bind(this),
            error: function(XMLHttpRequest, textStatus, errorThrown){
                if(errorThrown == 'Internal Server Error'){
                    this.setState({ errors: ['Internal Server Error']});
                    return;
                }
                this.setState({ errors: $.parseJSON(XMLHttpRequest.responseText)});
            }.bind(this)

        });

    },
    render: function(){

       var date = moment(this.props.petty_cash.created_at).format('dddd  D [de] MMMM  YYYY');
        var expense_count = 0;
        var title,expenses_form = null,expenses_size = 'col-md-6',close;
        if(this.props.petty_cash.closing_date){
            title = "Caja chica cerrada";
            expenses_size = 'col-md-12'
            close = true;
        }
        else{
            title = "Caja chica activa";
            expenses_form = <div className="col-md-6">
                                <PettyCashExpenseForm petty_cash_id={this.props.petty_cash.id} notifyParent={this.addNewExpense}/>
                            </div>;
            close = false;
        }
        if(this.state.petty_cash_expenses.length == 0){
            expenses = <div className='well'>No se han agregado gastos</div>
        }else{
            var expenses = this.state.petty_cash_expenses.map(function(expense){
                return <li key={expense.id} className="list-group-item">
                    <h4 className="list-group-item-heading">
                    {expense.concept}
                        <div className="pull-right"><label className="label label-primary "> $ {parseFloat(expense.amount).formatMoney(2)} </label></div>
                    </h4>
                    <div className="list-group-item-text">
                        Fecha: <strong>{moment(expense.expense_date).format('dddd  D [de] MMMM  YYYY')}<br/></strong>
                        Observaciones: <strong>{expense.observation}</strong>

                    </div>

                </li>;
            });
            this.state.petty_cash_expenses.map(function(expense){ expense_count += parseFloat(expense.amount)});
        }



       return (
           <div>
               <div className="page-header">
                   <h1>
                       <small>
                       {title}

                        </small>
                       <div className="pull-right"><button className="btn btn-primary" onClick={this.closePettyCash} disabled={close}>Corte de caja chica</button></div>
                   </h1>
               </div>
               <ErrorBox errorsArray={this.state.errors}/>
                   <h4 className="text-center cons-inf-title row">
                       <div className="row">
                           <div className='col-sm-4'>
                               <small className="text-muted">Cantidad $ <strong>{parseInt(this.props.petty_cash.amount).formatMoney()}</strong></small>
                           </div>
                           <div className='col-sm-4'>
                               <small className="text-muted">Se a gastado $ <strong>{expense_count.formatMoney()}</strong></small>
                           </div>
                           <div className='col-sm-4'>
                               <small className="text-muted">Fecha de inicio <strong>{date}</strong></small>
                           </div>
                       </div>
                   </h4>


               <div className="row">
                    {expenses_form}
                   <div className={expenses_size} >
                       <h4 className="text-center cons-inf-title">
                           <span className="text-muted">Gastos</span>
                       </h4>
                       <ul className="list-group" style={{height: '480px  ',overflowY: 'auto'}}>
                       {expenses}
                       </ul>
                   </div>
               </div>
           </div>
       )
    }
});