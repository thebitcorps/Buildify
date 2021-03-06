@DateInput = React.createClass
  getDefaultProps: ->
    minDate: 1, initToday: true
  componentDidMount: ->
    $('#' + "#{@props.name}").datetimepicker
      daysOfWeekDisabled: [ 0 ]
      showTodayButton: true
      keepOpen: true
      defaultDate: moment()
      format: 'DD/MM/YYYY'
      locale: 'es'
      minDate: moment().subtract(@props.minDate, 'weeks');
    that = @
    $('#' + "#{@props.name}").on 'dp.change', (e) ->
      that.changed(e)
    @props.changed  "#{@props.name}", moment().format('DD/MM/YYYY')
  changed: (e) ->
    @props.changed  "#{@props.name}", moment(e.date).format('DD/MM/YYYY')
  render: ->
    React.DOM.div
      className: 'form-group'
      style: {position: 'relative'}
      if @props.label
        React.DOM.label
          className: 'control-label'
          @props.label
      React.DOM.input
        disabled: @props.disabled
        type: 'text'
        className: 'form-control'
        placeholder: @props.placeholder
        name: @props.name
        id: @props.name
        value: @props.value


