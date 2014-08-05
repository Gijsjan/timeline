React = require 'react'

draggingOffset = null

setResetTimeout = do ->
    timer = null
    (ms, cb, onResetFn) ->

      if timer?
        onResetFn() if onResetFn?
        clearTimeout timer

      timer = setTimeout (->
        # clearTimeout frees the memory, but does not clear the var. So we manually clear it,
        # otherwise onResetFn will be called on the next call to timeoutWithReset.
        timer = null
        # Trigger the callback.
        cb()
      ), ms


module.exports = React.createClass
  componentDidMount: -> 
    window.addEventListener 'mouseup', @handleMouseUp
    window.addEventListener 'mousemove', @handleMouseMove

  componentWillUnmount: ->
    window.removeEventListener 'mouseup', @handleMouseUp
    window.removeEventListener 'mousemove', @handleMouseMove 

  handleMouseDown: (ev) ->
    nodeLeft = +(window.getComputedStyle(@getDOMNode()).left.slice(0, -2))
    draggingOffset = ev.clientX - nodeLeft

  handleMouseUp: (ev) ->
    if draggingOffset?
      @_handleMoveTimeline()
      draggingOffset = null

  handleMouseMove: (ev) ->
    if draggingOffset?
      @getDOMNode().style.left = (ev.clientX - draggingOffset) + 'px'
      @_handleMoveTimeline()

  render: ->
    if @props.timelineWidth > 0
      perc = window.innerWidth / @props.timelineWidth
      console.log (perc * 100) + '%'
      
      @getDOMNode().style.width = (perc * 100) + '%'

    <div className="slider" onMouseDown={@handleMouseDown} onMouseUp={@handleMouseUp} onMouseMove={@handleMouseMove}></div>

  _handleMoveTimeline: ->
    nodeLeft = +(window.getComputedStyle(@getDOMNode()).left.slice(0, -2))
    @props.onTimelineMove(nodeLeft / window.innerWidth)