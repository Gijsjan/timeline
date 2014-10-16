React = require 'react'

Year = require './year.cjsx'

Timeline = React.createClass

	render: ->
		startTimestamp = @props.firstDate.getTime() + ((@props.lastDate.getTime() - @props.firstDate.getTime()) * @props.percentage)
		startDate = new Date startTimestamp

		endDate = new Date(startDate)
		endDate.setDate(startDate.getDate() + 62)

		endDate = @props.lastDate if endDate > @props.lastDate

		gridSlice = {}
		while endDate >= startDate
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