@PurchaseOrderCreator = React.createClass
  getInitialState: ->
    itemMaterials: @props.requisition.item_materials
    selected: []
    selecting: true
  selectNewItemMaterial: (itemMaterial,is_new)->
    selected = @state.selected.slice()
    if is_new
      selected.push itemMaterial
    else
      index = selected.indexOf itemMaterial
      selected.splice index, 1
    @setState selected: selected
  letCreatePurchase: ->
    @state.selectedItemMaterials == null
  cancelPurchaseClick: ->
    @setState selecting: true
  handlePurchaseClick: ->

    @setState purchaseOrder: {itemMaterials: @state.selected, deliver: ''}
    @setState selecting: false
  render: ->
    React.DOM.div
      className: 'purchase_order_creator'
      React.DOM.table
        className: 'table table-striped'
        React.DOM.thead null,
          React.DOM.tr null,
            for th,i in ['','ID','Material','Description','Requested','Mesure unit']
              React.DOM.th key: i,th,
        React.DOM.tbody null,
          for itemMaterial in @state.itemMaterials
            React.createElement ItemMaterialPurchaseOrder, itemMaterial: itemMaterial,key: itemMaterial.id, handleSelect: @selectNewItemMaterial,can_select: @state.selecting
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
        unless @state.selecting
          React.createElement PurchaseOrder,purchaseOrder: @state.purchaseOrder,constructionAddress: @props.construction_address




