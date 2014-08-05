React = require 'react'
Month = require './month.cjsx'

monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

module.exports = React.createClass
  render: ->
    months = @props.months.map (days, i) => <Month days={days} month={monthNames[i]} />

    <li className="year">
        <h2>{@props.year}</h2>
        <ul className="months">
            {months}
        </ul>
    </li>