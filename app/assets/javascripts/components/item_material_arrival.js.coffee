@ItemMaterialArrival = React.createClass
  getInitialState: ->
    status: @props.itemMaterial.status
    rowColor: @getRowColor @props.itemMaterial.status
    edit: false
    requested: @props.itemMaterial.requested
    requested_new: @props.itemMaterial.requested
    measure_unit: @props.itemMaterial.measure_unit
    measure_unit_new: ''
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
    if @state.measure_unit_new
      return true
    false
  radioChanged: (name,value) ->
    @setState {status: value,rowColor: @getRowColor(value)}
    @props.itemMaterialChanged name,value
    that= @
    id =  that.props.itemMaterial.id
    $.ajax
      type: 'PUT'
      url: '/item_materials/'+ id
      data: {item_material: {status: value}}
      dataType: 'JSON'
      success:  (data) ->
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
      React.DOM.a
        href: '/materials/' + itemMaterial.material.id
        itemMaterial.material.name

  render: ->
    if @state.edit
      React.DOM.tr null,
        @nameLink(@props.itemMaterial)
        React.DOM.td null , React.createElement NumberInput,name: 'requested_new',value: @state.requested_new,changed: @handleInputChange
        React.DOM.td null ,React.createElement LabelSelect,name: 'measure_unit_new',options: @getUnitsOptions(@props.itemMaterial.material.measure_units),onChanged: @handleSelectChange
        React.DOM.td null ,
          React.DOM.a {className: 'btn btn-primary',onClick: @handleSubmit,disabled: !@valid()},'Guardar'
          React.DOM.a {className: 'btn btn-default',onClick: @handleToggle},'Cancelar'

    else
      React.DOM.tr className: @state.rowColor,
        @nameLink(@props.itemMaterial)
        React.DOM.td null,
          @state.requested + ' ' + @state.measure_unit
        React.DOM.td null,
          if @props.itemMaterial.purchase_order_id == null
            'No asignado'
          else
            React.DOM.a
              href: '/purchase_orders/' + @props.itemMaterial.purchase_order_id
              "Orden - #{@props.itemMaterial.purchase_order_id}"
        if @props.itemMaterial.purchase_order_id == null
          React.DOM.td null,
            React.DOM.div className: 'btn-group',
              React.DOM.a {className: 'btn btn-warning',onClick: @handleToggle},'Editar'
              React.DOM.a {className: 'btn btn-danger',onClick: @handleDelete},'Borrar'
        else
          React.DOM.td null,
            React.createElement LabelRadio, name: "#{@props.itemMaterial.id}",value: 'delivered',label: 'delivered',changed: @radioChanged,checked: @state.status == 'delivered'
            React.createElement LabelRadio, name: "#{@props.itemMaterial.id}",value: 'partially',label: 'partially',changed: @radioChanged,checked: @state.status == 'partially'
            React.createElement LabelRadio, name: "#{@props.itemMaterial.id}",value: 'missed',label: 'missed',changed: @radioChanged,checked: @state.status == 'missed'
            React.createElement LabelRadio, name: "#{@props.itemMaterial.id}",value: 'authorized',label: 'authorized',changed: @radioChanged,checked: @state.status == 'authorized'

