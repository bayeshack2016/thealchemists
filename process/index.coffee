fs = require 'fs'
path = require 'path'
d3 = require 'd3'

dataDir = path.join __dirname, "../data/"

loadTopo = (filename) ->
  json = JSON.parse(fs.readFileSync(filename).toString())
  return json

processPopulationsPEP = (countyHash, filename) ->
  rows = d3.csv.parse fs.readFileSync(filename).toString()
  console.log "PEP", rows.length, rows[1], Object.keys(rows[1]).filter (key) -> key.indexOf('2014') > 0
  rows.slice(1).forEach (row) ->
    fips = row["GEO.id2"];
    pop = +row["est72014sex0_age18to64"]

    countyHash[fips].properties.pop2014 = pop

processPopulationsCAS = (countyHash, filename) ->
  rows = d3.tsv.parse fs.readFileSync(filename).toString()
  console.log "CAS", rows.length, rows[0]
  rows.forEach (row) ->
    county = countyHash[row.FIPS]
    county.properties.pop1994 ?= 0
    if +row.age >= 18 and +row.age <= 64
      county.properties.pop1994 += +row['1994']


us = loadTopo dataDir + "us-named.topojson"
counties = us.objects.counties.geometries
  # we just export georgia for now
  .filter (d) ->
    return false if !d.properties
    # return true # all states
    return d.properties.id.slice(0, 2) == "13"

console.log "counties", counties.length
countyHash = {}
counties.forEach (county) ->
  countyHash[county.properties.id] = county; # string FIPS code: STXXX eg 13000 wher ST is state fips code

processPopulationsPEP countyHash, dataDir + "/PEP_2014_PEPAGESEX_with_ann.csv"
processPopulationsCAS countyHash, dataDir + "/Georgia-County-age-sex-1990-1999.tsv"


rows = counties.map (d) ->
  return d.properties
csv = d3.csv.format(rows)

fs.writeFileSync "../data/counties-joined.csv", csv
fs.writeFileSync "../data/us-joined.topojson", JSON.stringify us
