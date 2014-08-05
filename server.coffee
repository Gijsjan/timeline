# monk = require 'monk'
mongo = require 'mongodb'
MongoClient = mongo.MongoClient
ObjectID = mongo.ObjectID 
express = require 'express'
bodyParser = require 'body-parser'
app = express()
app.use bodyParser()
collection = null

# app.use (req, res, next) ->
# 	console.log req.body
# 	next()

sendResponse = (res, response) ->
	res.setHeader 'Content-Type', 'application/json'
	res.end JSON.stringify response

MongoClient.connect 'mongodb://127.0.0.1:27017/lewisandclark', (err, db) ->
	throw err if err?

	collection = db.collection 'journal-entries'
	
	app.listen 3000, -> console.log 'Listening on 3000'


app.get '/journal-entries', (req, res) ->
	fields =
		'author': 1
		'date': 1
		colspan: 1
		rowspan: 1
	sort = 
		'date': 1

	collection.find({}, fields).sort(sort).toArray (err, response) ->
		throw err if err?
		sendResponse res, response

app.get '/journal-entries/:id', (req, res) ->
	id = req.param('id')

	collection.findOne {_id: new ObjectID(id)}, {body: 1}, (err, response) ->
		throw err if err?
		sendResponse res, response

app.put '/journal-entries/:id', (req, res) ->
	id = req.param 'id'
	console.log id, req.body.colspan, req.body
	# collection.update {_id: new ObjectID(id)}
	res.send 200

	