Backbone = require 'backbone'
ActiveEntry = require './views/entry-active.cjsx'


class Router extends Backbone.Router
	routes:
		"": "home"
		"entry/:id": "entry"

	home: ->
		console.log 'home'


	entry: (id) ->
		console.log 'entry'
		Backbone.trigger 'set-active-entry', id
		

module.exports = Router