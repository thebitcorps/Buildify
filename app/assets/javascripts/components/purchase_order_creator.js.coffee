@PurchaseOrderCreator = React.createClass
  displayName: 'Purchase order creator'
  getInitialState: ->
    requisitionItemMaterials: @props.requisition.item_materials
    purchaseOrderItemsMaterials: []
    errors: []
  insertToArray: (item,array) ->
    newArray = array.slice()
    newArray.push item
    return newArray
  requisitionItemClick: (itemMaterial)->
    purchaseOrderItemsMaterials = React.addons.update(@state.purchaseOrderItemsMaterials, { $push: [itemMaterial] })
    requisiionItems = @state.requisitionItemMaterials.slice()
    index = requisiionItems.indexOf itemMaterial
    requisiionItems.splice index, 1
    @setState {requisitionItemMaterials: requisiionItems, purchaseOrderItemsMaterials: purchaseOrderItemsMaterials}
  purchaseItemClick: (itemMaterial)->
    requisitionItemMaterials = React.addons.update(@state.requisitionItemMaterials, { $push: [itemMaterial] })
    purchaseItems = @state.purchaseOrderItemsMaterials.slice()
    index = purchaseItems.indexOf itemMaterial
    purchaseItems.splice index, 1
    @setState {requisitionItemMaterials: requisitionItemMaterials, purchaseOrderItemsMaterials: purchaseItems}
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
    data = {delivery_place: @state.delivery_place,delivery_address: @state.delivery_address,delivery_receiver: @state.delivery_receiver,requisition_id: @props.requisition.id,item_material_ids: itemMaterialsIds}
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
  submitItemMaterialDivide: ->
    that = @
    $.ajax
      url: '/item_materials'
      type: 'POST'
      data: item_material: @state.newItemMaterial
      dataType: 'JSON'
      success:  (data) ->
        #update the browers window
        purchaseOrderItemsMaterials = React.addons.update(that.state.purchaseOrderItemsMaterials, { $push: [data] })
        that.setState purchaseOrderItemsMaterials:  purchaseOrderItemsMaterials
        return
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        #we parse the responses o errors so we can send a array of errors
        if errorThrown == 'Internal Server Error'
          that.setState errors: ['Internal Server Error']
          return
        that.setState errors: $.parseJSON(XMLHttpRequest.responseText)
        return
    $.ajax
      url: '/item_materials/'+ @state.dividerItemMaterial.id
      type: 'PUT'
      data: item_material: {requested: @state.dividerItemMaterial.requested}
      dataType: 'JSON'
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        #we parse the responses o errors so we can send a array of errors
        if errorThrown == 'Internal Server Error'
          that.setState errors: ['Internal Server Error']
          return
        that.setState errors: $.parseJSON(XMLHttpRequest.responseText)
    $("#modal").modal('hide')
  promptItemMaterialDivider: (itemMaterial) ->
    newItemMaterial = {material: {}}
    newItemMaterial.material.name = itemMaterial.material.name
    newItemMaterial.measure_unit = itemMaterial.measure_unit
    newItemMaterial.material.description = itemMaterial.material.description
    newItemMaterial.material_id = itemMaterial.material_id
    newItemMaterial.requisition_id = itemMaterial.requisition_id
    newItemMaterial.status = itemMaterial.status
    newItemMaterial.requested = 0
    @setState {dividerItemMaterial: itemMaterial,newItemMaterial: newItemMaterial}
    $("#modal").modal()
  updateRequested: (itemMaterial,operation)->
    itemMaterial.requested = operation(itemMaterial.requested)
    return itemMaterial

  substractRequestedToNew: ->
    @setState {dividerItemMaterial: @updateRequested(@state.dividerItemMaterial,(a)-> return parseInt(a) + 1),newItemMaterial: @updateRequested(@state.newItemMaterial,(a)-> return a - 1)}
  addRequestedToNew: ->
    @setState {dividerItemMaterial: @updateRequested(@state.dividerItemMaterial,(a)-> return parseInt(a) - 1),newItemMaterial: @updateRequested(@state.newItemMaterial,(a)-> return a + 1)}
  closeModal: ->
    b =  @state.newItemMaterial.requested
    @setState dividerItemMaterial: @updateRequested(@state.dividerItemMaterial,(a)-> return parseInt(a) + b)
    $("#modal").modal('hide')
  lessThaZeroOldItem: ->
    if @state.dividerItemMaterial
      return @state.dividerItemMaterial.requested == 0
  lessThaZeroNewItem: ->
    if @state.newItemMaterial
      return @state.newItemMaterial.requested == 0
  render: ->
    React.DOM.div
      className: 'purchase_order_creator'
      #||||||||||MODAL|||||||||||||
      React.DOM.div
        id: 'modal'
        tabIndex: '-1'
        role: 'modal'
        className: 'modal-dialog modal fade modal-lg'
        React.DOM.div
          className: 'modal-content'
          React.DOM.div
            className: 'modal-header'
            React.DOM.h4 null,'Dividir el pedido'
          React.DOM.div
            className: 'modal-body row'
            React.DOM.div
              className: 'col-md-5'
              React.DOM.ul
                style: {cursor: 'pointer'}
                className: 'list-group'
                if  @state.dividerItemMaterial
                  React.createElement ItemMaterialPurchaseOrder, itemMaterial: @state.dividerItemMaterial,can_select: true
            #||||||||Buttons||||||||
            React.DOM.div
              className: 'col-md-2'
#              React.DOM.p
              React.DOM.div
                className: 'row text-center'
                React.DOM.button {className: 'btn btn-primary ' ,onClick: @addRequestedToNew,disabled: @lessThaZeroOldItem()},'+'
#                React.DOM.p
                React.DOM.div
                  className: 'row text-center'
                  React.DOM.button {className: 'btn btn-default',onClick: @substractRequestedToNew,disabled: @lessThaZeroNewItem()},'-'
            React.DOM.div
              className: 'col-md-5'
              React.DOM.ul
                style: {cursor: 'pointer'}
                className: 'list-group'
                if  @state.newItemMaterial
                  React.createElement ItemMaterialPurchaseOrder, itemMaterial: @state.newItemMaterial,can_select: true
          React.DOM.div
            className: 'modal-footer'
            React.DOM.button
              className: 'btn btn-primary'
              onClick: @submitItemMaterialDivide
              disabled: @lessThaZeroNewItem() || @lessThaZeroOldItem()
              'Guardar'
            React.DOM.button
              className: 'btn btn-default'
              onClick: @closeModal
              'cancelar'
        #||||||||FORM||||||||||||||||
      React.DOM.div
        className: 'purchase-orders row'
        React.createElement ErrorBox, errorsArray: @state.errors
        React.createElement PurchaseOrderForm,purchaseOrder: @state.purchaseOrder,constructionAddress: @props.construction_address,itemMaterials: @state.selected,notifyParent: @addState
        #||||||||UNselected ItemMaterials|||||||||||||
        React.DOM.div
          className: 'col-md-6'
          React.DOM.h2 null, 'Materiales de la requisicion'
          React.DOM.ul
            style: {cursor: 'pointer'}
            className: 'list-group'
            if @state.requisitionItemMaterials.length == 0
              React.DOM.div
                className: 'panel panel-default'
                React.DOM.div
                  className: 'panel-body'
                  React.DOM.h4 null,
                    'No hay materiales para agregar'
            for itemMaterial in @state.requisitionItemMaterials
              if itemMaterial.status == 'pending'
                React.createElement ItemMaterialPurchaseOrder, itemMaterial: itemMaterial,key: itemMaterial.id, handleSelect: @requisitionItemClick,can_select: true,can_split: true,divideItemMaterial: @promptItemMaterialDivider
        #|||||||Selected ItemMaterials||||||||||||
        React.DOM.div
          className: 'col-md-6'
          React.DOM.h2 null, 'Materiales de la nueva orden de compra'
          React.DOM.ul
            style: {cursor: 'pointer'}
            className: 'list-group'
            if @state.purchaseOrderItemsMaterials.length == 0
              React.DOM.div
                className: 'panel panel-default'
                React.DOM.div
                  className: 'panel-body'
                  React.DOM.h4 null,
                    'Dar click en los materiales de la requisicion para agregar a la orden'
            for newItemMaterial in @state.purchaseOrderItemsMaterials
              React.createElement ItemMaterialPurchaseOrder, itemMaterial: newItemMaterial,key: newItemMaterial.id, handleSelect: @purchaseItemClick,can_select: true
      React.DOM.div
        className: 'row'
        React.DOM.button
          className: 'btn btn-primary'
          disabled: !@valid()
          onClick: @handlePurchaseOrderSubmit
          'Submit'



