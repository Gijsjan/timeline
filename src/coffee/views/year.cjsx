React = require 'react'
Month = require './month.cjsx'

module.exports = React.createClass
	render: ->
		months = @props.months.map (days, i) => 
			<Month grid={@props.grid} year={@props.year} month={i} days={days} />

		<li className="year">
			<h2>{@props.year}</h2>
			<ul className="months">
				{months}
			</ul>
		</li>