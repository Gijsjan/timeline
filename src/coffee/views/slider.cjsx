React = require 'react'

draggingOffset = null

# .leftOfSlider and .rightOfSlider overlap (resp. underlap) the border of the slider.
# Because of the border-radius, there is some space visible that doesn't have an opacity.
borderRadiusOffset = 3
headerHeight = 20

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
		diff = Math.ceil ((@props.lastDate-@props.firstDate)/(1000*60*60*24))
		timelineWidth = diff * 50

		perc = document.documentElement.clientWidth / timelineWidth

		sliderEl = @refs.slider.getDOMNode()
		

		clientHeight = document.documentElement.clientHeight
		scrollHeight = document.querySelector('ul.years').scrollHeight

		heightPerc = (clientHeight - headerHeight) / (scrollHeight - headerHeight)

		sliderEl.style.width = (perc * 100) + '%'
		sliderEl.style.height = (heightPerc * 100) + '%'


		# Get a reference to the @sliderWidth, so the style doesn't have to
		# be computed everytime the mousemove/touchchange event is fired.
		computedStyle = window.getComputedStyle(sliderEl)
		@sliderWidth = parseInt computedStyle.width
		@sliderHeight = parseInt computedStyle.height

		# @refs.above.getDOMNode().style.width = @sliderWidth + 'px'
		@refs.beneath.getDOMNode().style.top = (heightPerc * 100) + '%'
		@refs.beneath.getDOMNode().style.height = ((1 - heightPerc) * 100) + '%'
		@refs.beneath.getDOMNode().style.width = (@sliderWidth - (2*borderRadiusOffset)) + 'px'
		@refs.above.getDOMNode().style.width = (@sliderWidth - (2*borderRadiusOffset)) + 'px'

		window.addEventListener 'mouseup', @_handleMouseUp
		window.addEventListener 'mousemove', @_handleMouseMove

	componentWillUnmount: ->
		window.removeEventListener 'mouseup', @_handleMouseUp
		window.removeEventListener 'mousemove', @_handleMouseMove

	render: ->
		<div className="slider-container">
			<div
				ref="left" 
				className="leftOfSlider" />
			<div
				ref="above" 
				className="aboveSlider" />
			<div 
				ref="slider"
				className="slider" 
				onMouseDown={@_handleMouseDown}
				onMouseUp={@_handleMouseUp}
				onMouseMove={@_handleMouseMove} />
			<div
				ref="beneath" 
				className="beneathSlider" />
			<div
				ref="right" 
				className="rightOfSlider" />
		</div>

	_handleMouseDown: (ev) ->
		computedStyle = window.getComputedStyle(@refs.slider.getDOMNode())
		nodeLeft = +(computedStyle.left.slice(0, -2))
		nodeTop = +(computedStyle.top.slice(0, -2))

		draggingOffset =
			left: ev.clientX - nodeLeft
			top: ev.clientY - nodeTop

	_handleMouseUp: (ev) ->
		if draggingOffset?
			draggingOffset = null

	_handleMouseMove: (ev) ->
		if draggingOffset?
			left = ev.clientX - draggingOffset.left
			top = ev.clientY - draggingOffset.top

			@_setLeft left
			@_setTop top

			@_handleMoveSlider left, top

	_setLeft: (left) ->
		left = 0 if left < 0
		left = document.documentElement.clientWidth - @sliderWidth if (left + @sliderWidth) > document.documentElement.clientWidth
		@refs.left.getDOMNode().style.width = "#{left+3}px"
		@refs.above.getDOMNode().style.left = "#{left + borderRadiusOffset}px"
		@refs.slider.getDOMNode().style.left = "#{left}px"
		@refs.beneath.getDOMNode().style.left = "#{left + borderRadiusOffset}px"
		@refs.right.getDOMNode().style.left = "#{left + @sliderWidth - borderRadiusOffset}px"

	_setTop: (top) ->
		top = 0 if top < 0
		# TODO set bottom boundary
		@refs.slider.getDOMNode().style.top = "#{top}px"
		@refs.above.getDOMNode().style.height = "#{top}px"
		@refs.beneath.getDOMNode().style.top = "#{top + @sliderHeight}px"

	_handleMoveSlider: (left) ->
		@props.onSliderMove(left / document.documentElement.clientWidth)

	### Interface ###

	handleWheel: (ev) ->
		left = +@refs.slider.getDOMNode().style.left.slice(0, -2) + (ev.deltaY * -1)
		@_setLeft left

module.exports = Slider