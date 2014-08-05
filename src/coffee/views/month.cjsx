React = require 'react'
Day = require './day.cjsx'

module.exports = React.createClass
  render: ->
    days = @props.days.map (entries, i) => <Day entries={entries} day={i} />

    <li className="month">
        <h3>{@props.month}</h3>
        <ul className="days">
            {days}
        </ul>
    </li>