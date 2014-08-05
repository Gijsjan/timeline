Backbone = require 'backbone'
React = require 'react'
window.React = React

Router = require './router.cjsx'
Timeline = require './views/timeline.cjsx'
ActiveEntry = require './views/entry-active.cjsx'



done = ->
	console.log 'done'
	router = new Router()
	Backbone.history.start pushState: true

React.renderComponent(
	<Timeline />,
	document.getElementById('timeline')
);

React.renderComponent(
	<ActiveEntry />,
	document.getElementById('active-entry'),
	done
);