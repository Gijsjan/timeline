var getNextDate = function(date) {
  return new Date(date.getFullYear(), date.getMonth(), date.getDate() + 1);
};

var getNextDateArray = function(nextDate) {
  return [nextDate.getFullYear(), nextDate.getMonth(), nextDate.getDate()];
};

module.exports = function(entries) {
  var day, dayEntries, daysOfMonth, entry, entryIndex, findEmptySpace, grid, highestDate, i, index, lowestDate, month, nextDate, nextDay, nextMonth, nextYear, row, year, _base, _base1, _base2, _base3, _i, _len, _ref;
  grid = {};
  row = null;
  entryIndex = 0;
  daysOfMonth = function(month, year) {
    return new Date(year, month + 1, 0).getDate();
  };
  lowestDate = new Date(entries[0].date);
  lowestDate.setMonth(0);
  lowestDate.setDate(1);
  highestDate = new Date(entries[entries.length - 1].date);
  highestDate.setMonth(11);
  highestDate.setDate(31);
  entry = entries[0];

  while (lowestDate <= highestDate) {
    year = lowestDate.getFullYear();
    month = lowestDate.getMonth();
    day = lowestDate.getDate();
    if (grid[year] == null) {
      grid[year] = [];
    }
    if ((_base = grid[year])[month] == null) {
      _base[month] = [];
    }
    if ((_base1 = grid[year][month])[day] == null) {
      _base1[day] = [];
    }
    dayEntries = [];
    nextDate = getNextDate(lowestDate);
    _ref = getNextDateArray(nextDate), nextYear = _ref[0], nextMonth = _ref[1], nextDay = _ref[2];
    if (grid[nextYear] == null) {
      grid[nextYear] = [];
    }
    if ((_base2 = grid[nextYear])[nextMonth] == null) {
      _base2[nextMonth] = [];
    }
    if ((_base3 = grid[nextYear][nextMonth])[nextDay] == null) {
      _base3[nextDay] = [];
    }
    // console.log(entry.date.toISOString(), nextDate.toISOString())
    while ((entry != null) && entry.date.toISOString() === nextDate.toISOString()) {
      dayEntries.push(entryIndex);
      entryIndex += 1;
      entry = entries[entryIndex];
    }
    if (dayEntries.length > 0) {
      row = 0;
      findEmptySpace = function() {
        var i, space, _i, _ref1;
        while (grid[year][month][day][row] != null) {
          row += 1;
        }
        space = true;
        for (i = _i = row, _ref1 = row + dayEntries.length; row <= _ref1 ? _i < _ref1 : _i > _ref1; i = row <= _ref1 ? ++_i : --_i) {
          if (grid[year][month][day][i] != null) {
            space = false;
          }
        }
        if (!space) {
          row += 1;
          space = findEmptySpace();
        }
        return space;
      };
      findEmptySpace();

      for (i = _i = 0, _len = dayEntries.length; _i < _len; i = ++_i) {
        index = dayEntries[i];
        grid[year][month][day][row + i] = entries[index];
        grid[nextYear][nextMonth][nextDay][row + i] = -1;
      }
    }
    lowestDate = nextDate;
  }

  return function(done) {
    done(null, grid);
  }
};