Backbone = require 'backbone'
React = require 'react'
$ = require 'jquery'
_ = require 'underscore'
# createGrid = require '../../create-compact-grid'
Grid = require '../create-ordered-grid'

Year = require './year.cjsx'
Minimap = require './minimap.cjsx'

class Entry extends Backbone.Model
    idAttribute: '_id'

class Entries extends Backbone.Collection
    model: Entry

entries = null

module.exports = React.createClass

  getInitialState: ->
    entries: []
    timelineWidth: 0
  
  componentWillMount: ->
    $.get '/api/journal-entries', (response) =>
        console.log response
        entries = new Entries response
        @setState entries: entries

  componentDidMount: ->
    Backbone.on 'active-entry-change', @onActiveEntryChange, @

    setTimeout (=>
      @ulYears = @getDOMNode().querySelector('ul.years')
      @setState timelineWidth: +(window.getComputedStyle(@ulYears).width.slice(0, -2))
    ), 0

  onActiveEntryChange: (attrs, changedAttrs) ->   
    entry = @state.entries.get(attrs.id)
    entry.set changedAttrs

    @setState entries: entries

  handleTimelineMove: (perc) ->
    left = perc * @state.timelineWidth
    @ulYears.style.left = (-1 * left) + 'px'

  render: ->
    grid = if @state.entries.length > 0 then new Grid(@state.entries.toJSON()).grid else []

    years = _.map grid, (months, year) => <Year year={year} months={months} />

    <div className="timeline">
        <ul className="years">
          {years}
        </ul>
        <Minimap grid={grid} onTimelineMove={@handleTimelineMove} timelineWidth={@state.timelineWidth} />
    </div>