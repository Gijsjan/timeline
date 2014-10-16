React = require 'react'
Month = require './month.cjsx'

module.exports = React.createClass
	render: ->
		months = @props.months.map (days, i) => 
			<Month grid={@props.grid} year={@props.year} month={i} days={days} />

		# <h2>{@props.year}</h2>
		<li className="year" data-year={@props.year}>
			<ul className="months">
				{months}
			</ul>
		</li>