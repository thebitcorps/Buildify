// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require react
//= require react_ujs
//= require components
//= require moment
//= require moment/es
//= require bootstrap-datetimepicker
//= require pickers
//= require jquery.tokeninput
//= require cocoon
//= require_tree .


Number.prototype.formatMoney = function(c, d, t){
    var n = this,
        c = isNaN(c = Math.abs(c)) ? 2 : c,
        d = d == undefined ? "." : d,
        t = t == undefined ? "," : t,
        s = n < 0 ? "-" : "",
        i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
        j = (j = i.length) > 3 ? j % 3 : 0;
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};

window.createBillingAdjusment  = function(payment_id,payment_amount,paid_amount,construction_id){
    ReactDOM.render(React.createElement(BillingAdjusmentApp,{payment_id: payment_id,amount: payment_amount,paid_amount: paid_amount,construction_id: construction_id}),document.getElementById('billing'));
};
window.createPayment = function(construction_id){
    ReactDOM.render(React.createElement(PaymentModal,{construction_id: construction_id}),document.getElementById('mod'));

};

window.createInvoices = function(purchase_order_id, folio,construction_id){
    ReactDOM.render(React.createElement(InvoicesModal, {purchase_order_id: purchase_order_id, folio: folio,construction_id: construction_id}), document.getElementById('invoices'));
};

window.completeEstimate = function(estimate_id){
    ReactDOM.render(React.createElement(CompleteEstimateModal,{estimate_id: estimate_id}),document.getElementById('mod'));

};

var loadNotification = function () {
    $('#notification-container').click( function (event) {
        $('#notifications').html('<i class="fa fa-circle-o-notch text-primary fa-spin" />');
        $.ajax({
            method: "GET",
            dataType: "script",
            url: "/notifications",
            success: function(result){}
        });
    });
};

var loadToolptip = function(){
    $('[data-toggle="tooltip"]').tooltip();
};

// $(document).on('click', '.dropdown-menu', function (e) {
//     e.stopPropagation();
// });
$(document).on('page:load ready page:change', loadToolptip);
$(document).on('ready', loadNotification);