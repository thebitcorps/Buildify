var PettyCashApp = React.createClass({

    getInitialState: function(){
      return {petty_cash_expenses: this.props.petty_cash_expenses}
    },
    addNewExpense: function(expense){
        var expenses = this.state.petty_cash_expenses.slice();
        expenses.push(expense);
        this.setState({petty_cash_expenses: expenses});
    },
    render: function(){

       var date = moment(this.props.petty_cash.created_at).format('dddd  D [de] MMMM  YYYY');

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
        var expense_count = 0;
        this.state.petty_cash_expenses.map(function(expense){ expense_count += parseFloat(expense.amount)});
       return (
           <div>
               <div className="page-header">
                   <h1><small>
                       Caja chica
                       <div className="pull-right"><button className="btn btn-primary">Cerrar esta caja chica</button></div>
                   </small>
                   </h1>
                   <h4 className="text-center cons-inf-title row">
                       <div className='col-md-4'>
                           <small className="text-muted">Cantidad $ <strong>{parseInt(this.props.petty_cash.amount).formatMoney()}</strong></small>
                       </div>
                       <div className='col-md-4'>
                           <small className="text-muted">Se a gastado $ <strong>{expense_count.formatMoney()}</strong></small>
                       </div>
                       <div className='col-md-4'>
                           <small className="text-muted">Fecha de inicio <strong>{date}</strong></small>
                       </div>
                   </h4>

               </div>
               <div className="row">
                   <div className="col-md-6">
                       <PettyCashExpenseForm petty_cash_id={this.props.petty_cash.id} notifyParent={this.addNewExpense}/>
                   </div>
                   <div className="col-md-6" >
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