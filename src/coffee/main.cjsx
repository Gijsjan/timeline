Backbone = require 'backbone'
React = require 'react'
window.React = React

Router = require './router.cjsx'
App = require './views/app.cjsx'
ActiveEntry = require './views/entry-active.cjsx'

done = ->
	router = new Router()
	Backbone.history.start pushState: true

React.renderComponent(
	<App />,
	document.getElementById('timeline')
);

React.renderComponent(
	<ActiveEntry />,
	document.getElementById('active-entry'),
	done
);