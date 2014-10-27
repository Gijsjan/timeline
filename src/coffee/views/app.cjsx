Backbone = require 'backbone'
React = require 'react'
# createGrid = require '../../create-compact-grid'
Grid = require '../create-ordered-grid'

Timeline = require './timeline.cjsx'
Year = require './year.cjsx'
Minimap = require './minimap.cjsx'

data = require '../../../backend/metadata.json'
# data = require '../french-revolution'

class Entry extends Backbone.Model
	idAttribute: '_id'

class Entries extends Backbone.Collection
	model: Entry

module.exports = React.createClass

	getInitialState: ->
		grid = new Grid(data)
		gridData = grid.getData()

		data: gridData.originalData
		firstDate: gridData.firstDate
		lastDate: gridData.lastDate
		timelineWidth: document.documentElement.clientWidth
		percentage: 0
		timelineWidth: 0
		grid: gridData.grid

	handleSliderMove: (perc) ->
		@setState percentage: perc


	render: ->
		<div className="timeline">
			<Timeline 
				data={@state.data} 
				grid={@state.grid} 
				percentage={@state.percentage}
				firstDate={@state.firstDate}
				lastDate={@state.lastDate} />
			<Minimap 
				data={@state.data} 
				grid={@state.grid} 
				onSliderMove={@handleSliderMove}
				firstDate={@state.firstDate}
				lastDate={@state.lastDate} />
		</div>