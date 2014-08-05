# Reads lewisandclark.html and puts the entries in the mongodb.

htmlparser = require 'htmlparser2'
fs = require 'fs'

els = []
title = false
body = false
pre = false

MongoClient = require('mongodb').MongoClient
format = require('util').format

trim = (str) -> str.replace(/^\s+|\s+$/g, '')
replaceNewlines = (str) -> str.replace(/\n/g, '')

parser = new htmlparser.Parser
    onopentag: (name, attrs) ->
        if name is 'h2'
            title = true
        else if name is 'p'
            body = true
        else if name is 'pre'
            pre = true



    ontext: (text) ->
        if title
            els.push "<h2>#{trim(text)}</h2>"
        else if body
            els.push "<p>#{replaceNewlines(trim(text))}</p>"
        else if pre
            els.push "<pre>#{text}</pre>"

    onclosetag: (name) ->
        title = false
        body = false
        pre = false

fs.readFile './lewisclark.html', 'utf8', (err, html) ->
    return err if err?

    parser.write html
    parser.end()

    events = []
    event = {}

    for line in els
        if line.substr(0,4) is '<h2>' and event?
            # console.log event
            events.push event

            t = line.replace '<h2>[', ''
            t = t.replace ']</h2>', ''
            t = t.split(',')

            event =
                author: t[0]
                date: new Date(t[1] + ',' + t[2])
                title: line
                'colspan': 2
                'rowspan': 1
                body: ''
        else
            event.body += line

    MongoClient.connect 'mongodb://127.0.0.1:27017/lewisandclark', (err, db) ->
        throw err if err?

        collection = db.collection 'journal-entries'
        # console.log events
        collection.insert events, (err, docs) ->
            

            db.close()