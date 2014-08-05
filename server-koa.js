var mongo = require('mongodb');
var MongoClient = mongo.MongoClient;
var ObjectID = mongo.ObjectID;
var koa = require('koa');
var route = require('koa-route');
var app = koa();
var parse = require('co-body');
var createGrid = require('./create-ordered-grid');


 
var db, collection;

 
MongoClient.connect('mongodb://127.0.0.1:27017/lewisandclark', function (err, db) {
  collection = db.collection('journal-entries');

  app.listen(3000);
  console.log('Listening on 3000');
});
 
app.use(route.get('/journal-entries', function *() {
  var fields = {
    author: 1,
    date: 1,
    colspan: 1,
    rowspan: 1
  }

  var entries = yield collection.find({}, fields).sort({date: 1}).toArray;
  this.body = entries;

  // var grid = yield createGrid(entries);
  // this.body = grid;

}));

// app.get '/journal-entries/:id', (req, res) ->
//   id = req.param('id')

//   collection.findOne {_id: new ObjectID(id)}, {body: 1}, (err, response) ->
//     throw err if err?
//     sendResponse res, response

app.use(route.get('/journal-entries/:id', function *(id) {
  this.body = yield function(done) {
    collection.findOne({_id: new ObjectID(id)}, {body: 1}, done);
  };
}));
 
app.use(route.put('/journal-entries/:id', function *(id) {
  var body = yield parse.json(this);
  updateResult = yield function (done) {
    collection.update({_id: new ObjectID(id)}, {$set: body}, done);
  };
 
  var status = updateResult[0] > 0 ? 200 : 403;
  this.status = status;
}));