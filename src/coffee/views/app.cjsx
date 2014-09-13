Backbone = require 'backbone'
React = require 'react'
$ = require 'jquery'
_ = require 'underscore'
# createGrid = require '../../create-compact-grid'
Grid = require '../create-ordered-grid'

Timeline = require './timeline.cjsx'
Year = require './year.cjsx'
Minimap = require './minimap.cjsx'

data = require '../french-revolution'

class Entry extends Backbone.Model
		idAttribute: '_id'

class Entries extends Backbone.Collection
		model: Entry

entries = null

module.exports = React.createClass

	getInitialState: ->
		timelineWidth: window.innerWidth
		grid: new Grid(data).grid
		percentage: 0
		timelineWidth: 0

	handleSliderMove: (perc) ->
		@setState percentage: perc

	render: ->
		# years = _.map @state.grid, (months, year) => <Year year={year} months={months} />

		<div className="timeline">
			<Timeline grid={@state.grid} percentage={@state.percentage} timelineWidth={@state.timelineWidth} />
			<Minimap grid={@state.grid} onSliderMove={@handleSliderMove} timelineWidth={@state.timelineWidth} />
		</div>