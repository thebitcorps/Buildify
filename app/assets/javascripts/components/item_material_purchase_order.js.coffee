@ItemMaterialPurchaseOrder = React.createClass
  getInitialState: ->
    itemMaterial: @props.itemMaterial
    selected: false
  itemCheck: (e) ->
    @setState selected: e.target.checked
#    we send the !@state.selected for some reason in handleSelect the state is no set already
    @props.handleSelect @state.itemMaterial,!@state.selected
  render: ->
    React.DOM.tr
      className: "#{'info'  if @state.selected}"
      React.DOM.td null,
        React.DOM.input
          type: 'checkbox'
          disabled: !@props.can_select
          onChange: @itemCheck
      React.DOM.td null,
        @state.itemMaterial.id
      React.DOM.td null,
        @state.itemMaterial.material.name
      React.DOM.td null,
        @state.itemMaterial.material.description
      React.DOM.td null,
        @state.itemMaterial.requested
      React.DOM.td null,
        @state.itemMaterial.mesure_unit
