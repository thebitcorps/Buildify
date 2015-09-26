@ItemMaterial = React.createClass
  getInitialState: ->
    edit: false
    material_name: @props.itemMaterial.material_name
    material_id: @props.itemMaterial.material_id
    requested: @props.itemMaterial.requested
    mesure_unit: @props.itemMaterial.mesure_unit
  handleDelete: ->
    @props.handleDeleteItemMaterial @props.itemMaterial
  handleInputChange: (name,value) ->
    @setState "#{name}": value
  handleEdit: ->
    new_item =
      id: @props.itemMaterial.id
      material_id: @state.material_id
      requested: @state.requested
      mesure_unit: @state.mesure_unit
    @props.handleUpdate @props.itemMaterial,new_item
    @setState edit: false
  handleToggle: ->
    @setState edit: !@state.edit
  renderForm: ->
    React.DOM.tr null,
      React.DOM.td null,
        React.createElement LabelInput,name: 'material_id',value: @state.material_id,changed: @handleInputChange
      React.DOM.td null,
        React.createElement LabelInput,name: 'requested',value: @state.requested,changed: @handleInputChange
      React.DOM.td null,
        React.createElement LabelInput,name: 'mesure_unit',changed: @handleInputChange,value: @state.mesure_unit
      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-warning'
          onClick: @handleEdit
          'Update'
        React.DOM.a
          className: 'btn btn-default'
          onClick: @handleToggle
          'Cancel'
  renderRow: ->
    React.DOM.tr null,
#      React.DOM.td null,
#        @state.material_id
      React.DOM.td null,
        @state.material_name
      React.DOM.td null,
        "#{@state.requested} #{@state.measure_unit}"
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

