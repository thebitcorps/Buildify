
(function(){
    /**
     *
     * @param concept
     * @param amount
     * @param payment_date
     * @param construction_id
     * @constructor
     */
    self.Payment = function(concept,amount,payment_date,construction_id){
        this.concept = concept;
        this.payment_date = payment_date;
        this.construction_id = construction_id;
        this.amount = amount;
    }
})();


