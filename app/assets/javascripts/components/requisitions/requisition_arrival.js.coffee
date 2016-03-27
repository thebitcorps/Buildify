@RequisitionArrival = React.createClass
  getInitialState: ->
    itemMaterials: @props.itemMaterials

  itemMaterialUpdate: (itemId,newStatus,received)->
    items = @state.itemMaterials.slice()
    for itemMaterial in items
      if itemMaterial.id == parseInt itemId,10
        itemMaterial.status = newStatus
        itemMaterial.received = received
        @replaceState itemMaterials: items
        return
  removeItemMaterial: (itemMaterial) ->
    itemMaterials = @state.itemMaterials.slice()
    index = itemMaterials.indexOf itemMaterial
    itemMaterials.splice index, 1
    @setState itemMaterials: itemMaterials
  closeModal: ->
    $("#partially").modal('hide')
    @setState received: @props.received
  validPartiallyArrive: ->
    @state.received ? true : false
  handlePartially: (itemId)->
    for itemMaterial in @state.itemMaterials
      if itemMaterial.id == itemId
        selectItem  = itemMaterial
        break
    @setState {requested: selectItem.requested,measure_unit: selectItem.measure_unit,partialItem: selectItem}
    $("#partially").modal('show')
  partiallyArriveSave: ->
    $.ajax
      type: 'PUT'
      url: '/item_materials/'+ @state.partialItem.id
      data: {item_material: {received: @state.received,status: 'partially'}}
      dataType: 'JSON'
      success: ( (data) ->
        @itemMaterialUpdate(data.id,'partially',@state.received)
        #function that updat the item material in the parent
#        @props.itemMaterialChanged that.props.itemMaterial.id,'partially',that.state.received
        @closeModal()
        ).bind(this)
      error: ((XMLHttpRequest, textStatus, errorThrown) ->
        #we parse the responses o errors so we can send a array of errors
        if errorThrown == 'Internal Server Error'
          @setState errors: ['Internal Server Error']
          return
        @setState errors: $.parseJSON(XMLHttpRequest.responseText)
        return).bind(this)
  handleInputChange: (name, value) ->
    @setState "#{name}": value
  render: ->
    React.DOM.div
      className: 'requisition-arrival'
      #    ||||||||||MODAL|||||||
      React.DOM.div
        id: 'partially'
        tabIndex: '-1'
        role: 'modal'
        className: 'modal-dialog modal fade'
        React.DOM.div
          className: 'modal-content'
          React.DOM.div
            className: 'modal-header'
            React.DOM.h4 null,'Cuanto Llego'
          React.DOM.div
            className: 'modal-body'
            React.DOM.label className: 'form-group','Se pidio:'
              React.DOM.div
                className: 'input-group '
                React.createElement LabelInput,name: 'requested',changed: @handleInputChange,disabled: true,value: "#{@state.requested }"
                React.DOM.span className: 'input-group-addon',@state.measure_unit
              React.DOM.label className: 'form-group','Llego:'
              React.DOM.div
                className: 'input-group '
                React.createElement NumberInput,name: 'received',value: @state.received,changed: @handleInputChange
                React.DOM.span className: 'input-group-addon',@state.measure_unit
            React.DOM.div
              className: 'modal-footer'
              React.DOM.button
                className: 'btn btn-primary'
                onClick: @partiallyArriveSave
                disabled: !@validPartiallyArrive()
                'Guardar'
              React.DOM.button
                className: 'btn btn-default'
                onClick: @closeModal
                'cancelar'
      React.DOM.div
        className: 'panel panel-default table-responsive '
        React.DOM.table
          className: 'table table-hover'
          React.DOM.thead null,
            #maye remove the Estado th and left only the actions
            for th,index in ['Material','Pedido','Orden de Compra','Estado del producto']
              React.DOM.th key: index, th
          React.DOM.tbody null,
            for itemMaterial in @state.itemMaterials
              React.createElement ItemMaterialArrival, key: itemMaterial.id, itemMaterial: itemMaterial, itemMaterialChanged: @itemMaterialUpdate, administrator: @props.administrator, handleDelete: @removeItemMaterial, partiallyChange: @handlePartially

