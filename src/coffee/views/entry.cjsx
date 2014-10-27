React = require 'react'

module.exports = React.createClass
  handleClick: (ev) ->

  render: ->
    className = "entry row#{@props.row} colspan#{@props.data.colspan} rowspan#{@props.data.rowspan}"

    if @props.data.image?
    	image = <img src={@props.data.image.src} data-date={@props.data.date} />

    if @props.data.text? and @props.data.text.title?
      title = <h5>{@props.data.text.title}</h5>
    else
      className += " without-title"

    <li key={@props.data.image.src} className={className} onClick={@handleClick}>
      {image}
      {title}
      <div className="fader"></div>
    </li>