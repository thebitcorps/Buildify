@PurchaseOrderCreator = React.createClass
  getInitialState: ->
#    itemMaterials: @props.requisition.item_materials
    selected: []
    selecting: true
    purchaseOrder:
      itemMaterials: []
  selectNewItemMaterial: (itemMaterial,is_new)->
    selected = @state.selected.slice()
    if is_new
      selected.push itemMaterial
    else
      index = selected.indexOf itemMaterial
      selected.splice index, 1
    @setState selected: selected
    @setState purchaseOrder: {itemMaterials: @state.selected}

#    @handlePurchaseClick()
  letCreatePurchase: ->
    @state.selectedItemMaterials == null
  cancelPurchaseClick: ->
    @setState selecting: true
  handlePurchaseClick: ->
    @setState purchaseOrder: {itemMaterials: @state.selected}
    @setState selecting: false
  render: ->
    React.DOM.div
      className: 'purchase_order_creator'
      React.DOM.ul
        className: 'list-group'
        for itemMaterial in @props.requisition.item_materials
          React.createElement ItemMaterialPurchaseOrder, itemMaterial: itemMaterial,key: itemMaterial.id, handleSelect: @selectNewItemMaterial,can_select: @state.selecting
      if @state.selecting
        React.DOM.button
          className: 'btn btn-primary'
          onClick: @handlePurchaseClick
          'Submit'
      unless @state.selecting
        React.DOM.button
          className: 'btn btn-default'
          onClick: @cancelPurchaseClick
          'Cancel'
      React.DOM.div
        className: 'purchase-orders'
#        unless @state.selecting
        React.createElement PurchaseOrder,purchaseOrder: @state.purchaseOrder,constructionAddress: @props.construction_address,itemMaterials: @state.selected




