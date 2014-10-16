React = require 'react'
Entry = require './entry.cjsx'

module.exports = React.createClass
	render: ->
		entries2 = @props.grid[@props.year][@props.month][@props.day]
		entries = entries2.map (data, row) =>
			if data isnt -1
				<Entry row={row} data={data} />

		<li className="day">
			<h4>{@props.day}</h4>
			<ul className="entries">
				{entries}
			</ul>
		</li>