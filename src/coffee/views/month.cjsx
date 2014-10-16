React = require 'react'
Day = require './day.cjsx'

monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

module.exports = React.createClass
	render: ->
		days = @props.days.map (value, index) => 
			<Day grid={@props.grid} year={@props.year} month={@props.month} day={index} />

		# <h3>{monthNames[@props.month]}</h3>
		<li className="month">
			<ul className="days">
				{days}
			</ul>
		</li>