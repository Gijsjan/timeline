XLSX = require('xlsx')
xlsx = XLSX.readFile('zkh-head.xlsx')
jsesc = require 'jsesc'
fs = require 'fs'

for sheetName in xlsx.SheetNames
	sheet = xlsx.Sheets[sheetName]
	array = XLSX.utils.sheet_to_row_object_array(sheet)
	fs.writeFile __dirname+'/'+sheetName, JSON.stringify(array), (err) ->
		if err?
			console.log err
		else
			console.log 'saved'