
fs = require 'fs'
path = require 'path'
d3 = require 'd3'
request = require 'request'
async = require 'async'

dataDir = path.join __dirname, "../data/ga"

processYear = (year) ->
  console.log year
  counties = d3.csv.parse(fs.readFileSync(dataDir + "counties-joined-#{year}.csv").toString())
  countyHash = {}
  counties.forEach (county) ->
    countyHash[county.id] = county; # string id is FIPS code: STXXX eg 13000 wher ST is state fips code
  keysOfInterest = [
    'labor_force'
    'employed'
    'unemployed'
    'unemployment_rate'
  ]
  filename = dataDir + "county-employment/county-#{year}.csv"
  rows = d3.csv.parse fs.readFileSync(filename).toString()
  rows.forEach (row) ->
    # TODO: filter down to just agg level and industries we may care about
    # for now, just use totals
    countyId = row.FIPS_state + "" + row.FIPS_county
    county = countyHash[countyId]
    return unless county
    for key in keysOfInterest
      county[key] = row[key]

  csv = d3.csv.format(counties)
  fs.writeFileSync dataDir + "counties-joined-#{year}.csv", csv

d3.range(2000, 2015).forEach (year) ->
  processYear (year + "")
