@ItemMaterialArrival = React.createClass
  getInitialState: ->
    status: @props.itemMaterial.status
    rowColor: @getRowColor @props.itemMaterial.status
    edit: false
    received: @props.itemMaterial.received
    requested: @props.itemMaterial.requested
    requested_new: @props.itemMaterial.requested
    measure_unit: @props.itemMaterial.measure_unit
    measure_unit_new: ''
    administrator: @props.administrator
  getUnitsOptions: (measures)->
    units = [{'display' : '','value': ''}]
    for measure_unit in measures
      units.push  {'display' : "#{measure_unit.unit} | #{measure_unit.abbreviation}" ,'value': measure_unit.abbreviation }
    return units
  getRowColor: (status) ->
    if @props.itemMaterial.purchase_order_id == null
      return 'default'
    if status == 'missed'
      return 'danger'
    else if status == 'delivered'
      return 'success'
    else if status == 'partially'
      return 'warning'
    else
      return 'dafault'
  handleToggle: ->
    @setState edit: !@state.edit
  handleSelectChange: (value) ->
    @setState measure_unit_new: value
  handleInputChange: (name, value) ->
    @setState "#{name}": value
  handleDelete: ->
    that = @
    answer = confirm("Desea eliminar este material de la requisicion")
    unless answer
      return
    $.ajax
      method: 'DELETE'
      url: "/item_materials/#{ @props.itemMaterial.id }"
      dataType: 'JSON'
      success: (data) ->
        that.props.handleDelete that.props.itemMaterial
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        alert 'error'
        return
  handleSubmit: ->
    $.ajax
      type: 'PUT'
      url: '/item_materials/'+@props.itemMaterial.id
      data: {item_material: {requested: @state.requested_new,measure_unit: @state.measure_unit_new}}
      dataType: 'JSON'
      success:  (data) ->
        alert 'Material Actualizado'
        return
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        #we parse the responses o errors so we can send a array of errors
        if errorThrown == 'Internal Server Error'
          that.setState errors: ['Internal Server Error']
          return
        that.setState errors: $.parseJSON(XMLHttpRequest.responseText)
        return
    @setState {requested: @state.requested_new,edit: false,measure_unit: @state.measure_unit_new,measure_unit_new: ''}
  valid: ->
    @state.measure_unit_new ? true : false
  validPartiallyArrive: ->
    @state.received ? true : false
  partiallyRadioChange:(name,value) ->
#    @setState {status: value,rowColor: @getRowColor(value)}
#    @props.itemMaterialChanged name,value
    $("#" + @props.itemMaterial.id).modal()
  partiallyArriveSave: ->
    that= @
    id =  that.props.itemMaterial.id
    $.ajax
      type: 'PUT'
      url: '/item_materials/'+ id
      data: {item_material: {received: @state.received,status: 'partially'}}
      dataType: 'JSON'
      success:  (data) ->
        that.setState {status: 'partially',rowColor: that.getRowColor('partially')}
        #function that updat the item material in the parent
        that.props.itemMaterialChanged that.props.itemMaterial.id,'partially',that.state.received
        $("#" + that.props.itemMaterial.id).modal('hide')
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        #we parse the responses o errors so we can send a array of errors
        if errorThrown == 'Internal Server Error'
          that.setState errors: ['Internal Server Error']
          return
        that.setState errors: $.parseJSON(XMLHttpRequest.responseText)
        return

  radioChanged: (name,value) ->
    received = ''
    if value == 'delivered'
      received = @props.itemMaterial.requested
    else if value == 'missed'
      received = '0'
    that= @
    id =  that.props.itemMaterial.id
    $.ajax
      type: 'PUT'
      url: '/item_materials/'+ id
      data: {item_material: {status: value,  received: received}}
      dataType: 'JSON'
      success:  (data) ->
        that.setState {status: value,rowColor: that.getRowColor(value),received: received}
        that.props.itemMaterialChanged name,value,received
        return
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        #we parse the responses o errors so we can send a array of errors
        if errorThrown == 'Internal Server Error'
          that.setState errors: ['Internal Server Error']
          return
        that.setState errors: $.parseJSON(XMLHttpRequest.responseText)
        return
  nameLink: (itemMaterial)->
    React.DOM.td null,
      if @props.administrator
        React.DOM.a
          href: '/materials/' + itemMaterial.material.id
          itemMaterial.material.name
      else
        itemMaterial.material.name
  closeModal: ->
    $("#" + @props.itemMaterial.id).modal('hide')
    @setState received: @props.received
  render: ->
    if @state.edit
      React.DOM.tr null,
        @nameLink(@props.itemMaterial)
        React.DOM.td null , React.createElement NumberInput,name: 'requested_new',value: @state.requested_new,changed: @handleInputChange
        React.DOM.td null ,React.createElement LabelSelect,name: 'measure_unit_new',options: @getUnitsOptions(@props.itemMaterial.material.measure_units),onChanged: @handleSelectChange
        React.DOM.td null ,
          React.DOM.div className: 'btn-group',
            React.DOM.a {className: 'btn btn-primary',onClick: @handleSubmit,disabled: !@valid()},'Guardar'
            React.DOM.a {className: 'btn btn-default',onClick: @handleToggle},'Cancelar'
    else
      React.DOM.tr className: @state.rowColor,
        @nameLink(@props.itemMaterial)
        React.DOM.td null,
          @state.requested + ' ' + @state.measure_unit
        React.DOM.td null,
          #if no purchase order have been generate we show proper message
          if @props.itemMaterial.purchase_order_id == null
            'No asignado'
          else
            if @state.administrator
              React.DOM.a
                href: '/purchase_orders/' + @props.itemMaterial.purchase_order_id
                "Orden - #{@props.itemMaterial.purchase_order_id}"
            else
              "Orden - #{@props.itemMaterial.purchase_order_id}"
        #add prop for the requisition state nly show buttons when requisitons is process
        #here we can edit the item material
        if @props.itemMaterial.purchase_order_id == null
          React.DOM.td null,
            React.DOM.div className: 'btn-group',
              React.DOM.a {className: 'btn btn-warning',onClick: @handleToggle},'Editar'
              React.DOM.a {className: 'btn btn-danger',onClick: @handleDelete},'Borrar'
        else
          React.DOM.div
            clasName: ''
#         |||||||||Purchase order already generated here we  select the arrival status
            React.DOM.td null,
              React.createElement LabelRadio, name: "#{@props.itemMaterial.id}",value: 'authorized',label: 'Por llegar',changed: @radioChanged,checked: @state.status == 'authorized'
              React.createElement LabelRadio, name: "#{@props.itemMaterial.id}",value: 'delivered',label: 'Entregado',changed: @radioChanged,checked: @state.status == 'delivered'
              React.createElement LabelRadio, name: "#{@props.itemMaterial.id}",value: 'partially',label: 'Parcialmente',changed: @partiallyRadioChange,checked: @state.status == 'partially'
              React.createElement LabelRadio, name: "#{@props.itemMaterial.id}",value: 'missed',label: 'No entregado',changed: @radioChanged,checked: @state.status == 'missed'
#        ||||||||||MODAL|||||||
            React.DOM.div
              id: @props.itemMaterial.id
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
                      React.createElement LabelInput,name: 'received',changed: @handleInputChange,disabled: true,value: "#{@props.itemMaterial.requested }"
                      React.DOM.span className: 'input-group-addon',@props.itemMaterial.measure_unit
                    React.DOM.label className: 'form-group','Llego:'
                    React.DOM.div
                      className: 'input-group '
                      React.createElement NumberInput,name: 'received',value: @state.received,changed: @handleInputChange
                      React.DOM.span className: 'input-group-addon',@props.itemMaterial.measure_unit
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
