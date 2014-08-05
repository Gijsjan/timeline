module.exports = (entries) ->
	grid = [[]]
	column = 0
	row = 0
	entryIndex = 0

	daysOfMonth = (month, year) -> new Date(year, month+1, 0).getDate()
			
	lowestDate = new Date entries[0].date
	lowestDate.setMonth 0
	lowestDate.setDate 1

	highestDate = new Date entries[entries.length-1].date
	highestDate.setMonth 11
	highestDate.setDate 31

	entry = entries[0]

	while lowestDate <= highestDate
		month = lowestDate.getMonth()
		year = lowestDate.getFullYear()
		
		# Start day on lenght of days of current month. Ie 28, 29, 30 or 31.
		# day = daysOfMonth(month, year) - 1
		day = 0
		# Loop all days of the current month
		while day < daysOfMonth(month, year)
			dayEntries = []
			grid[column] ?= []

			while entry? and entry.date is new Date(year, month, day+1).toISOString()
				dayEntries.push entryIndex
				entryIndex += 1
				entry = entries[entryIndex]
			
			if dayEntries.length > 0	
				findEmptySpace = ->
					row += 1 while grid[column][row]?

					space = true

					for i in [row...row+dayEntries.length]
						space = false if grid[column][i]?

					if not space
						row += 1
						space = findEmptySpace()

					space

				findEmptySpace()

				for i in [row...row+dayEntries.length]
					grid[column][i] = dayEntries[i - row]
					grid[column+1] ?= []
					grid[column+1][i] = -1

			row = 0
			column += 1
			day += 1

		lowestDate.setMonth month + 1

	# console.log grid
	grid