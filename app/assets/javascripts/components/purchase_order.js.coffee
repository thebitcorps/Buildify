@PurchaseOrder = React.createClass
  getInitialState: ->
    itemMaterials: @props.itemMaterials
  render: ->
    React.DOM.div
      className: 'purchase-order'
      React.DOM.div
        className: 'purchase-form'

