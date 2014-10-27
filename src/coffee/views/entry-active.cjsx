React = require 'react'
Backbone = require 'backbone'

module.exports = React.createClass
  getInitialState: ->
    active: false
    id: null
    author: null
    date: null
    colspan: null
    rowspan: null
    body: null

  componentDidMount: ->
    Backbone.on 'set-active-entry', @setActiveEntry, @

  setActiveEntry: (entry) ->
    console.log entry
    Backbone.history.navigate "entry/#{entry._id}"
    $.get "/api/journal-entries/#{entry._id}", (entryData) => 
      @setState
        active: true
        id: entry._id
        author: entry.author
        date: entry.date
        colspan: entry.colspan
        rowspan: entry.rowspan
        body: entryData.body

  handleClick: (ev) -> 
    Backbone.history.navigate ""
    @setState @getInitialState()

  handleColspanChange: (ev) -> 
    data = colspan: +ev.target.value
    @setState data
    Backbone.trigger 'active-entry-change', @state, data
    
    xhr = new XMLHttpRequest()
    xhr.onreadystatechange = =>
      if xhr.readyState is XMLHttpRequest.DONE
        console.log 'xhr', xhr
    data = JSON.stringify data
    xhr.open 'PUT', "/api/journal-entries/#{@state.id}"
    xhr.setRequestHeader('Content-Type','application/json');

    xhr.send data

  handleRowspanChange: (ev) ->
    data = rowspan: +ev.target.value
    @setState data
    Backbone.trigger 'active-entry-change', @state, data

  render: ->
    className = "entry-active"
    className += " active" if @state.active

    <div className={className}>
      <h5>{@state.author}</h5>
      <div className="date">{new Date(@state.date).toDateString()}</div>
      <i className="fa fa-edit" />
      <i className="fa fa-times" onClick={@handleClick} />
      <form className="edit-menu">
        <label>Colspan</label>
        <input ref="colspan", type="text", value={@state.colspan} onChange={this.handleColspanChange} />
        <label>Rowspan</label>
        <input ref="rowspan", type="text", value={@state.rowspan}  onChange={this.handleRowspanChange} />
      </form>
      <div className="body" dangerouslySetInnerHTML={{__html: @state.body}} />
    </div>