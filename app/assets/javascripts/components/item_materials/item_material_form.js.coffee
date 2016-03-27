@ItemMaterialForm = React.createClass
  displayName: 'Item material form'
  getInitialState: ->
    material_id: ''
    requested: ''
    measure_unit: ''
    material: {measure_units: []}
  valid: ->
    @state.material_id_hidden && @state.requested && @state.measure_unit
  handleInputChange: (name,value) ->
    @setState "#{name}": value
  handleSelectChange: (value) ->
    @setState measure_unit: value
  handleNew: (e)->
    e.preventDefault()
    data =
      id:  @state.material_id_hidden
      material_id: @state.material_id_hidden
      material_name: @state.material_name_hidden
      requested: @state.requested
      measure_unit: @state.measure_unit
      material: @state.material
    $("#material").tokenInput('clear')
    @props.handleNewItemMaterial data
    @setState @getInitialState
  onTokenAdded: (item) ->
#    alert item.measure_units[0]
    @setState {material_id_hidden: item.id, material_name_hidden: item.name,material: item}
  removeToken: (item) ->
    @setState {material_id_hidden: '',material_name_hidden: '',material: {measure_units: []}}
  units: ->
    units = [{'display' : '','value': ''}]
    for measure_unit in @state.material.measure_units
      units.push  {'display' : "#{measure_unit.unit} | #{measure_unit.abbreviation}" ,'value': measure_unit.abbreviation }
    return units
  hiddenInput: (name) ->
    React.DOM.input
      type: 'hidden'
      id: name
      placeholder: name
      ref: name
      name: name
  createMaterialForm: ->
    alert('caca');
  render: ->
#    return "<button class='btn btn-primary' onClick={alert('caca');}>Agregar nuevo material </button>"
    noResult = "<button class='btn btn-primary' onclick={ReactDOM.render(React.createElement(MaterialModal),document.getElementById('new-material'))}>Agregar nuevo material </button>"
    React.DOM.div
      className: ''
      React.DOM.div
        className: 'form-group typehead'
#        React.createElement LabelInput,label: 'Material ',name: 'material_id',placeholder: 'Material',changed: @handleInputChange,value: @state.material_id
        React.DOM.label
          className: 'control-label'
          'Buscador de material'
        React.createElement TokenInput,componentName: 'material',url: '/materials.json', onAddToken: @onTokenAdded, onRemoveToken: @removeToken,withDescription: true,allowCreation: noResult
        React.createElement LabelSelect, label: 'Unidad del material',name: 'measure_unit',options: @units(),onChanged: @handleSelectChange
        React.createElement NumberInput,label: 'Cantidad requerida ',name: 'requested',placeholder: 'Cantidad numerica',changed: @handleInputChange,value: @state.requested
#        React.createElement LabelInput,label: 'Mesure unit ',name: 'measure_unit',placeholder: 'Mesure unit',changed: @handleInputChange,value: @state.measure_unit

        React.DOM.button
          className: 'btn btn-primary'
          onClick: @handleNew
          disabled: !@valid()
          'Agregar material a la requisicion'