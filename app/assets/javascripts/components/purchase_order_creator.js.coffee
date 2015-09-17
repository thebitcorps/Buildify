@PurchaseOrderCreator = React.createClass
  getInitialState: ->
    requisitionItemMaterials: @props.requisition.item_materials
    purchaseOrderItemsMaterials: []
  requisitionItemClick: (itemMaterial)->
    requisiionItems = @state.requisitionItemMaterials.slice()
    purchaseItems = @state.purchaseOrderItemsMaterials.slice()
    purchaseItems.push itemMaterial
    index = requisiionItems.indexOf itemMaterial
    requisiionItems.splice index, 1
    @setState requisitionItemMaterials: requisiionItems
    @setState purchaseOrderItemsMaterials: purchaseItems

  purchaseItemClick: (itemMaterial)->
    requisiionItems = @state.requisitionItemMaterials.slice()
    purchaseItems = @state.purchaseOrderItemsMaterials.slice()
    requisiionItems.push itemMaterial
    index = purchaseItems.indexOf itemMaterial
    purchaseItems.splice index, 1
    @setState requisitionItemMaterials: requisiionItems
    @setState purchaseOrderItemsMaterials: purchaseItems
  render: ->
    React.DOM.div
      className: 'purchase_order_creator'
      React.DOM.div
        className: 'purchase-orders'
#        unless @state.selecting
        React.createElement PurchaseOrderForm,purchaseOrder: @state.purchaseOrder,constructionAddress: @props.construction_address,itemMaterials: @state.selected
        React.DOM.div
          className: 'col-md-6'
          React.DOM.h2 null, 'Requisition'
          React.DOM.ul
            className: 'list-group'
            for itemMaterial in @state.requisitionItemMaterials
              React.createElement ItemMaterialPurchaseOrder, itemMaterial: itemMaterial,key: itemMaterial.id, handleSelect: @requisitionItemClick,can_select: true
        React.DOM.div
          className: 'col-md-6'
          React.DOM.h2 null, 'Purchase Order'
          React.DOM.ul
            className: 'list-group'
            if @state.purchaseOrderItemsMaterials.length == 0
              React.DOM.div
                className: 'panel panel-default'
                React.DOM.div
                  className: 'panel-body'
                  React.DOM.h4 null,
                    'Click in one item in the requisition items to add'
            for newItemMaterial in @state.purchaseOrderItemsMaterials
              React.createElement ItemMaterialPurchaseOrder, itemMaterial: newItemMaterial,key: newItemMaterial.id, handleSelect: @purchaseItemClick,can_select: true



