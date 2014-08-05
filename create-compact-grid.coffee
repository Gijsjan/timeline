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
			while entry? and entry.date is new Date(year, month, day+1).toISOString()

				grid[column] ?= []
				grid[column+1] ?= []
				
				row += 1 while grid[column][row]?

				grid[column][row] = entryIndex
				grid[column+1][row] = -1
				# grid[row][column+1] = entryIndex

				entryIndex += 1
				entry = entries[entryIndex]

			row = 0
			column += 1
			day += 1

		lowestDate.setMonth month + 1

	grid