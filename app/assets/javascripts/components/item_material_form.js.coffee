@ItemMaterialForm = React.createClass
  getInitialState: ->
    material_id: ''
    requested: ''
    mesure_unit: ''
    units: []
  valid: ->
    @state.material_id_hidden && @state.requested && @state.mesure_unit
  handleInputChange: (name,value) ->
    @setState "#{name}": value
  handleSelectChange: (value) ->
    @setState mesure_unit: value
  handleNew: (e)->
    e.preventDefault()
    data =
      material_id: @state.material_id_hidden
      material_name: @state.material_name_hidden
      requested: @state.requested
      mesure_unit: @state.mesure_unit
    $("#material").tokenInput('clear')
    @props.handleNewItemMaterial data
    @setState @getInitialState
  onTokenAdded: (item) ->
#    alert item.measure_units[0]
    units = [{'display' : '','value': ''}]
    for measure_unit in item.measure_units
      units.push  {'display' : "#{measure_unit.unit} | #{measure_unit.abbreviation}" ,'value': measure_unit.abbreviation }
    @setState {material_id_hidden: item.id, material_name_hidden: item.name,units: units}
  removeToken: (item) ->
    @setState {material_id_hidden: '',material_name_hidden: '',units: []}
  hiddenInput: (name) ->
    React.DOM.input
      type: 'hidden'
      id: name
      placeholder: name
      ref: name
      name: name



  render: ->
    React.DOM.div
      className: ''
      React.DOM.div
        className: 'form-group typehead'
#        React.createElement LabelInput,label: 'Material ',name: 'material_id',placeholder: 'Material',changed: @handleInputChange,value: @state.material_id
        React.DOM.label
          className: 'control-label'
          'Material'
        React.createElement TokenInput,componentName: 'material',url: '/materials.json', onAddToken: @onTokenAdded, onRemoveToken: @removeToken
        React.createElement LabelInput,label: 'Requested ',name: 'requested',placeholder: 'Request',changed: @handleInputChange,value: @state.requested
#        React.createElement LabelInput,label: 'Mesure unit ',name: 'measure_unit',placeholder: 'Mesure unit',changed: @handleInputChange,value: @state.measure_unit
        React.createElement LabelSelect, label: 'Mesure unit',name: 'mesure_unit',options: @state.units,onChanged: @handleSelectChange
        React.DOM.button
          className: 'btn btn-primary'
          onClick: @handleNew
          disabled: !@valid()
          'Submit'