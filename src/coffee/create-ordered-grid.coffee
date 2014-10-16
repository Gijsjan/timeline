_ = require 'underscore'

class Grid
	constructor: (@entries) ->
		for entry in @entries
			if typeof entry.date is 'string'
				entry.date = new Date(entry.date)
				entry.date.setHours(0)
				entry.date.setMinutes(0)
				entry.date.setSeconds(0)

		@originalData = _.clone(@entries)

		@grid = {}
		row = null
		entryIndex = 0
		@currentDate = new Date @entries[0].date
		@currentDate.setDate 1
		@firstDate = new Date(@currentDate)

		@highestDate = new Date @entries[@entries.length-1].date
		@highestDate.setDate 31


		while @currentDate <= @highestDate		

			currentDateEntries = @getEntriesOnCurrentDate()

			if currentDateEntries.length > 0
				totalRowSpan = _.reduce currentDateEntries, ((memo, entry) -> memo + entry.rowspan), 0

				startingRow = @findStartingRow 0, totalRowSpan

				for entry, i in currentDateEntries
					@addEntryPointsToGrid entry, startingRow, i
					startingRow = startingRow + entry.rowspan
			else
				@addPoint @currentDate

			# console.log @grid[year][month][day] if @dateToArray(@currentDate)[0] is 1804 and @dateToArray(@currentDate)[1] is 5 and @dateToArray(@currentDate)[2] is 24
			@currentDate = @getNextDate @currentDate
		
		window.grid = @grid

	getData: ->
		firstDate: @firstDate
		lastDate: @highestDate
		originalData: @originalData
		grid: @grid

	addEntryPointsToGrid1: (entry, row, i) ->
		currentRow = row + i
		@addPoint @currentDate, currentRow, entry
		# @grid[year][month][day][currentRow] = entry

		# TODO use columnDate in while statement so we don't need colspan and colspan
		colspan = entry.colspan - 1
		columnDate = @getNextDate @currentDate
		while colspan > 0
			@addPoint columnDate, currentRow
			colspan--
			columnDate = @getNextDate columnDate

		rowspan = entry.rowspan - 1
		while rowspan > 0
			currentRow = currentRow + 1
			@addPoint columnDate, currentRow
			rowspan--

		row = currentRow

	addEntryPointsToGrid: (entry, startingRow, i) ->
		
		# @addPoint @currentDate, currentRow, entry
		# @grid[year][month][day][currentRow] = entry

		# TODO use columnDate in while statement so we don't need colspan and colspan
		colspan = 0
		columnDate = @currentDate

		while colspan < entry.colspan
			currentRow = startingRow
			while currentRow < (startingRow + entry.rowspan)
				# console.log colspan is 0, currentRow, startingRow if entry._id is '538a462754263dba5b935e68'
				if colspan is 0 and currentRow is startingRow
					@addPoint columnDate, currentRow, entry
				else
					@addPoint columnDate, currentRow

				currentRow = currentRow + 1
				# rowspan++

			columnDate = @getNextDate columnDate
			colspan++

	getEntriesOnCurrentDate: ->
		arr = []
		entry = @entries[0]

		# FIXME Shifted entry is used in the while, but the next entry should be used.
		while entry? and entry.date.getTime() is @currentDate.getTime()
			entry = @entries.shift()
			arr.push entry if entry?

			entry = @entries[0]

		arr

	daysOfMonth: (month, year) -> new Date(year, month+1, 0).getDate()

	getNextDate: (date) -> new Date date.getFullYear(), date.getMonth(), date.getDate() + 1

	dateToArray: (date) -> [date.getFullYear(), date.getMonth(), date.getDate()]

	dateInGrid: (date) ->
		[year, month, day] = @dateToArray date

		@grid[year] ?= []
		@grid[year][month] ?= []
		@grid[year][month][day] ?= []

		@grid[year][month][day]

	# Find the row to start putting the entries on.
	# Example: there are 3 entries on the currentDate, if row 1 and 2 are empty,
	# but row 3 is occupied, row 4 should be returned.
	findStartingRow: (currentRow, totalRowSpan) ->
		space = true

		dateInGrid = @dateInGrid @currentDate

		# Find the first empty currentRow.
		while dateInGrid[currentRow]?
			currentRow += 1

		# Check if the rows to be occupied are empty.
		# If totalRowSpan is 4, there should be (at least)
		# 4 empty rows.
		for i in [currentRow...currentRow+totalRowSpan]
			space = false if dateInGrid[i]?

		# If there is no space
		if not space
			currentRow = currentRow + 1
			return @findStartingRow currentRow, totalRowSpan

		currentRow

	addPoint: (date, row=0, value=-1) ->
		@dateInGrid(date)[row] = value

module.exports = Grid