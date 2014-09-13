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


Slider = React.createClass
	componentDidMount: -> 
		window.addEventListener 'mouseup', @_handleMouseUp
		window.addEventListener 'mousemove', @_handleMouseMove

	componentWillUnmount: ->
		window.removeEventListener 'mouseup', @_handleMouseUp
		window.removeEventListener 'mousemove', @_handleMouseMove 

	render: ->
		if @props.timelineWidth > 0
			perc = window.innerWidth / @props.timelineWidth
			console.log (perc * 100) + '%'
			
			@getDOMNode().style.width = (perc * 100) + '%'

		<div className="slider" onMouseDown={@_handleMouseDown} onMouseUp={@_handleMouseUp} onMouseMove={@_handleMouseMove}></div>

	_handleMouseDown: (ev) ->
		nodeLeft = +(window.getComputedStyle(@getDOMNode()).left.slice(0, -2))
		draggingOffset = ev.clientX - nodeLeft

	_handleMouseUp: (ev) ->
		if draggingOffset?
			# @_handleMoveSlider()
			draggingOffset = null

	_handleMouseMove: (ev) ->
		if draggingOffset?
			@getDOMNode().style.left = (ev.clientX - draggingOffset) + 'px'
			@_handleMoveSlider()

	_handleMoveSlider: ->
		nodeLeft = +(window.getComputedStyle(@getDOMNode()).left.slice(0, -2))
		@props.onSliderMove(nodeLeft / window.innerWidth)

module.exports = Slider