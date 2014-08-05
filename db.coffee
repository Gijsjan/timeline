MongoClient = require('mongodb').MongoClient
db = null
collections = {}

module.exports = (databaseName) ->
	(collectionName, done) ->
		if db? and collection.hasOwnProperty collectionName
			done collection[collectionName], db
		else
			MongoClient.connect 'mongodb://127.0.0.1:27017/'+databaseName, (err, db) ->
				throw err if err?
				collections[collectionName] = db.collection(collectionName)
				done collections[collectionName], db
