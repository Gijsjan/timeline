React = require 'react'
Slider = require './slider.cjsx'

module.exports = React.createClass
	componentDidMount: ->
		node = @getDOMNode()
		node.querySelector('svg').setAttribute 'preserveAspectRatio', 'none'

	componentDidUpdate: (prevProps, prevState) ->
		@

	render: ->
		eArr = []

		for year, months of @props.grid
			for month in months
				if month?
					for day in month
						if day?
							entries = 0
							for point in day
								entries++ if point? and point isnt -1
							eArr.push entries

		max = 0
		lines = eArr.map (e, i) ->
			max = e if e > max
			<rect x={i} y="0" width="1" height={e} />

		background = [0...max].map (lineNo) ->
			evenodd = if lineNo % 2 is 0 then 'even' else 'odd'
			<rect x="0" y={lineNo} height="1" width={lines.length} className={evenodd} />
	
		viewBox = "0 0 #{lines.length} #{max}"

		<div className="minimap" onWheel={@_handleWheel}>
			<Slider 
				ref="mySlider"
				grid={@props.grid}
				data={@props.data}
				onSliderMove={@props.onSliderMove}
				firstDate={@props.firstDate}
				lastDate={@props.lastDate} />
			<svg viewBox={viewBox} preserveAspectRatio="none" width="100%" height="100%">
				{background}
				{lines}
			</svg>
		</div>

	_handleWheel: (ev) ->
		@refs.mySlider.handleWheel ev
