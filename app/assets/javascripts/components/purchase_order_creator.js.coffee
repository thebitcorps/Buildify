@PurchaseOrderCreator = React.createClass
  getInitialState: ->
    requisitionItemMaterials: @props.requisition.item_materials
    purchaseOrderItemsMaterials: []
    errors: []
  requisitionItemClick: (itemMaterial)->
    requisiionItems = @state.requisitionItemMaterials.slice()
    purchaseItems = @state.purchaseOrderItemsMaterials.slice()
    purchaseItems.push itemMaterial
    index = requisiionItems.indexOf itemMaterial
    requisiionItems.splice index, 1
    @setState {requisitionItemMaterials: requisiionItems, purchaseOrderItemsMaterials: purchaseItems}
  purchaseItemClick: (itemMaterial)->
    requisiionItems = @state.requisitionItemMaterials.slice()
    purchaseItems = @state.purchaseOrderItemsMaterials.slice()
    requisiionItems.push itemMaterial
    index = purchaseItems.indexOf itemMaterial
    purchaseItems.splice index, 1
    @setState {requisitionItemMaterials: requisiionItems, purchaseOrderItemsMaterials: purchaseItems}
  addState: (toAdd) ->
    @setState toAdd
  valid: ->
#    alert @state.provider_id_hidden && @state.provider_name_hidden && @state.provider_address && @state.delivery_address && @state.delivery_type && @state.delivery_receiver
    @state.provider_id_hidden && @state.provider_name_hidden && @state.provider_address && @state.delivery_address && @state.delivery_type && @state.delivery_receiver
  handlePurchaseOrderSubmit: ->
#   if item material is 0 dont let permit
    if @state.purchaseOrderItemsMaterials.length == 0
      @setState errors: ['You need to select at least one item']
      return
    itemMaterialsIds = []
    for itemMaterial in @state.purchaseOrderItemsMaterials
      itemMaterialsIds.push itemMaterial.id
    data =
      delivery_place: @state.delivery_place
      delivery_address: @state.delivery_address
      delivery_receiver: @state.delivery_receiver
      requisition_id: @props.requisition.id
      item_material_ids: itemMaterialsIds
    that = @
    $.ajax
      url: '/purchase_orders.json'
      type: 'POST'
      data: {purchase_order: data,provider_id: @state.provider_id_hidden}
      dataType: 'JSON'
      success:  (data) ->
        #update the browers window
        window.location.replace('/purchase_orders/' + data.id)
        return
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        #we parse the responses o errors so we can send a array of errors
        if errorThrown == 'Internal Server Error'
          that.setState errors: ['Internal Server Error']
          return
        that.setState errors: $.parseJSON(XMLHttpRequest.responseText)
        return
  render: ->

    React.DOM.div
      className: 'purchase_order_creator'
      React.DOM.div
        className: 'purchase-orders row'
        React.createElement ErrorBox, errorsArray: @state.errors
        React.createElement PurchaseOrderForm,purchaseOrder: @state.purchaseOrder,constructionAddress: @props.construction_address,itemMaterials: @state.selected,notifyParent: @addState
        React.DOM.div
          className: 'col-md-6'
          React.DOM.h2 null, 'Requisition'
          React.DOM.ul
            style: {cursor: 'pointer'}
            className: 'list-group'
            if @state.requisitionItemMaterials.length == 0
              React.DOM.div
                className: 'panel panel-default'
                React.DOM.div
                  className: 'panel-body'
                  React.DOM.h4 null,
                    'No more requisition items to add'
            for itemMaterial in @state.requisitionItemMaterials
              if itemMaterial.status == 'pending'
                React.createElement ItemMaterialPurchaseOrder, itemMaterial: itemMaterial,key: itemMaterial.id, handleSelect: @requisitionItemClick,can_select: true
        React.DOM.div
          className: 'col-md-6'
          React.DOM.h2 null, 'Purchase Order'
          React.DOM.ul
            style: {cursor: 'pointer'}
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
      React.DOM.div
        className: 'row'
        React.DOM.button
          className: 'btn btn-primary'
          disabled: !@valid()
          onClick: @handlePurchaseOrderSubmit
          'Submit'



