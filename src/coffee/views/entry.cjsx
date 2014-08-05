React = require 'react'
$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $

module.exports = React.createClass
  handleClick: (ev) ->
    Backbone.trigger 'set-active-entry', @props.data

  render: ->
    className = "entry row#{@props.row} colspan#{@props.data.colspan} rowspan#{@props.data.rowspan}"

    <li className={className} onClick={@handleClick}>
      <h5>{@props.data.author}</h5>
    </li>