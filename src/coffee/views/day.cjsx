React = require 'react'
Entry = require './entry.cjsx'

module.exports = React.createClass
  render: ->
    entries = @props.entries.map (data, row) =>
        if data isnt -1
            <Entry row={row} data={data} />

    <li className="day">
        <h4>{@props.day}</h4>
        <ul className="entries">
            {entries}
        </ul>
    </li>