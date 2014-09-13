React = require 'react'

Year = require './year.cjsx'

Timeline = React.createClass

	render: ->
		firstDate = new Date(1789, 6, 1)
		lastDate = new Date(1794, 6, 1)
		startTimestamp = firstDate.getTime() + ((lastDate.getTime() - firstDate.getTime()) * @props.percentage)
		startDate = new Date startTimestamp

		endDate = new Date(startDate)
		endDate.setDate(startDate.getDate() + 32)

		gridSlice = {}
		while endDate > startDate
			[year, month, day] = [startDate.getFullYear(), startDate.getMonth(), startDate.getDate()]
			gridSlice[year] ?= []
			gridSlice[year][month] ?= []
			gridSlice[year][month][day] ?= null

			startDate.setDate(startDate.getDate() + 1)

		years = Object.keys(gridSlice).map (year) =>
			months = gridSlice[year]
			<Year grid={@props.grid} year={year} months={months} />

		<ul className="years">
			{years}
		</ul>

module.exports = Timeline