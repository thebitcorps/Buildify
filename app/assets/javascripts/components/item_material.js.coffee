@ItemMaterial = React.createClass
  getInitialState: ->
    getMaterialName = (props) ->
      if props.itemMaterial.material_name
        return props.itemMaterial.material_name
      else
        return props.itemMaterial.material.name
    edit: false
    material_name: getMaterialName(@props)
    material_id: @props.itemMaterial.material_id
    requested: @props.itemMaterial.requested
    measure_unit: @props.itemMaterial.measure_unit
  handleSelectChange: (value) ->
    @setState measure_unit: value
  handleDelete: ->
    @props.handleDeleteItemMaterial @props.itemMaterial
  handleInputChange: (name,value) ->
    @setState "#{name}": value
  handleEdit: (e)->
    @props.handleUpdate @props.itemMaterial,@state
    @setState edit: false
  handleToggle: ->
    @setState edit: !@state.edit
  units: ->
    units = [{'display' : '','value': ''}]
    for measure_unit in @props.itemMaterial.material.measure_units
      units.push  {'display' : "#{measure_unit.unit} | #{measure_unit.abbreviation}" ,'value': measure_unit.abbreviation }
    return units
  renderForm: ->
    React.DOM.tr null,
      React.DOM.td null,@state.material_name
      React.DOM.td null,
        React.createElement NumberInput,name: 'requested',value: @state.requested,changed: @handleInputChange
      React.DOM.td null,
        React.createElement LabelSelect,name: 'measure_unit',options: @units(),onChanged: @handleSelectChange

      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-warning'
          onClick: @handleToggle
          'Update'
        React.DOM.a
          className: 'btn btn-default'
          onClick: @handleToggle
          'Cancel'
  renderRow: ->
    React.DOM.tr null,
      React.DOM.td null,@state.material_name
      React.DOM.td null,"#{@state.requested} #{@state.measure_unit}"
      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-warning'
          onClick: @handleToggle
          'Edit'
        React.DOM.a
          className: 'btn btn-danger'
          onClick: @handleDelete
          'Delete'
  render: ->
    if @state.edit
      @renderForm()
    else
      @renderRow()

