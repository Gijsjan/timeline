chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'

chai.should()
chai.use sinonChai

getNextDate = (date) -> new Date date.getFullYear(), date.getMonth(), date.getDate() + 1

testFun = (entry) ->
    currentDate = entry.date

    # TODO use columnDate in while statement so we don't need colspan and colspan
    colspan = 0
    columnDate = getNextDate currentDate

    grid = []

    while colspan isnt entry.colspan
        rowspan = 0

        while rowspan isnt entry.rowspan
          grid[rowspan] ?= []
          grid[rowspan][colspan] = if rowspan is 0 and colspan is 0 then 'object' else -1
          rowspan++

        colspan++

    grid

describe 'View Main', ->
  describe 'initialize', ->
    it 'should have a model', ->
      entry =
        date: new Date()
        colspan: 3
        rowspan: 2

      console.log testFun(entry)
      testFun(entry).should.eql [
        ['object', -1, -1],
        [-1, -1, -1]
      ]

