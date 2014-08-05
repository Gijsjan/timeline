XLSX = require 'xlsx'
xlsx = XLSX.readFile 'zkh.xlsx'

pg = require 'pg'
conString = "postgres://media:media@localhost/zkh"

client = new pg.Client conString
client.connect (err) ->
	return console.error 'error fetching client from pool', err if err?

for sheetName in xlsx.SheetNames
	sheet = xlsx.Sheets[sheetName]
	for data in XLSX.utils.sheet_to_row_object_array(sheet)
		
		query = "
			INSERT INTO 
				indicatoren
				(set_id, code, nummer, type, label, operationalisatie, eenheid, waarde, teller, noemer, nb, nvt, toelichting) 
			VALUES 
				((SELECT id FROM indicator_sets WHERE naam='#{data.Indicator_set}'), $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
		"
		
		values = [data.Indicator_code, data.Indicator_nummer, data.Indicator_type, data.Indicator_label, data.Operationalisatie, data.Indicator_eenheid, data.Indicator_waarde, data.Teller, data.Noemer, data.Indicator_nb, data.Indicator_nvt, data.Toelichting]
		
		client.query query, values, (err, result) ->
			console.log err if err?