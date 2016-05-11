@ItemMaterialForm = React.createClass
  displayName: 'Item material form'
  getInitialState: ->
    material_id: ''
    requested: ''
    measure_unit: ''
    material: {measure_units: []}
    tokenClean: true
    token: ''
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
    @props.handleNewItemMaterial data
    @setState @getInitialState
  onTokenAdded: (item) ->
#    alert item.measure_units[0]
    @setState {material_id_hidden: item.id, material_name_hidden: item.name,material: item,tokenClean: false}
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
  showMaterialModal: (value)->
    @setState {material_name_hidden: value}
    $('#modal').modal();
  closeModal: (material)->
    $('#modal').modal('hide');
  render: ->
#    noResult = "<button class='btn btn-primary' onclick={ReactDOM.render(React.createElement(MaterialModal),document.getElementById('new-material'))}>Agregar nuevo material </button>"
    React.DOM.div
      className: ''
      React.DOM.div
        id: 'modal'
        className: 'modal fade'
        tabIndex: '-1'
        role: "dialog"
        React.DOM.div
          className: 'modal-dialog'
          React.DOM.div
            className: 'modal-content'
            React.DOM.div
              className: 'modal-header'
              React.DOM.h4
                className: 'modal-title'
                'Nuevo Material'
            React.DOM.div
              className: 'modal-body'
              React.createElement MaterialModal,onClose: @closeModal,materialAdded: @onTokenAdded,name: @state.material_name_hidden,
      React.DOM.div
        className: 'table-responsive'
        React.DOM.table
          className: 'table table-striped'
          React.DOM.tbody null,
            React.DOM.tr null,
              for th,i in ['Material','Unidad ','Cantidad','Accion']
                React.DOM.th key: i,th
            React.DOM.tr null,
              React.DOM.td null,
  #              React.createElement TokenInput,componentName: 'material',url: '/materials.json', onAddToken: @onTokenAdded, onRemoveToken: @removeToken,withDescription: true,allowCreation: noResult
                React.createElement TokenInputCustom,url: '/materials.json',queryParam: 'search[query]',tokenAdded: @onTokenAdded,tokenRemoved: @removeToken,clean: this.state.tokenClean,noResultAction: @showMaterialModal,noResultMessage: 'No se encontro. Click para agregar nuevo',outsideToken: this.state.material_name_hidden
              React.DOM.td null,
                React.createElement LabelSelect,name: 'measure_unit',options: @units(),onChanged: @handleSelectChange
              React.DOM.td null,
                React.createElement NumberInput,name: 'requested',placeholder: 'Cantidad numerica',changed: @handleInputChange,value: @state.requested
              React.DOM.td null,
                React.DOM.button
                  className: 'btn btn-primary'
                  onClick: @handleNew
                  disabled: !@valid()
                  'Agregar material '