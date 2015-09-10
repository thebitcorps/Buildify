@ItemMaterialForm = React.createClass
  getInitialState: ->
    material_id: ''
    requested: ''
    mesure_unit: ''
    material_id_hidden: ''
  componentDidMount: ->
    $("#material").tokenInput("/materials.json", {
      crossDomain: false,
      prePopulate: $("#material").data("pre"),
      theme: "facebook"
      queryParam: 'search[query]'
      tokenLimit: 1
      onAdd: (item) ->
        $('#material_id_hidden').val(item.id)
        $('#material_name_hidden').val item.name
      onDelete: (item) ->
        $('#material_id_hidden').val ''
        $('#material_name_hidden').val ''
    })
  caca: (e) ->
    alert 'caca'
  valid: ->
    ($('#material_id_hidden').val()) != '' && @state.requested && @state.mesure_unit
  handleInputChange: (name,value) ->
    @setState "#{name}": value
  handleNew: (e)->
    e.preventDefault()
    data =
      material_id: React.findDOMNode(@refs.material_id_hidden).value
      material_name: React.findDOMNode(@refs.material_name_hidden).value
      requested: @state.requested
      mesure_unit: @state.mesure_unit
    $("#material").tokenInput('clear')
    @props.handleNewItemMaterial data
    @setState @getInitialState
  hiddenInput: (name) ->
    React.DOM.input
      type: 'hidden'
      id: name
      placeholder: name
      ref: name
      name: name
  render: ->
    React.DOM.form
      className: 'form-inline'
      React.DOM.div
        className: 'form-group typehead'
#        React.createElement LabelInput,label: 'Material ',name: 'material_id',placeholder: 'Material',changed: @handleInputChange,value: @state.material_id
        React.DOM.label
          className: 'control-label'
          'Material'
        React.DOM.input
          type: 'hidden'
          id: 'material'
          className: 'form-control'
          placeholder: 'material'
          ref: 'material'
          name: 'material'
        @hiddenInput 'material_name_hidden'
        @hiddenInput 'material_id_hidden'

        React.createElement LabelInput,label: 'Requested ',name: 'requested',placeholder: 'Request',changed: @handleInputChange,value: @state.requested
        React.createElement LabelInput,label: 'Mesure unit ',name: 'mesure_unit',placeholder: 'Mesure unit',changed: @handleInputChange,value: @state.mesure_unit
        React.DOM.button
          className: 'btn btn-primary'
          onClick: @handleNew
          disabled: !@valid()
          'Submit'