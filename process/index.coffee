fs = require 'fs'
path = require 'path'
d3 = require 'd3'

dataDir = path.join __dirname, "../data/"

loadTopo = (filename) ->
  json = JSON.parse(fs.readFileSync(filename).toString())
  return json


processPopulations2014 = (countyHash, filename) ->
  ages = [
    "est72014sex0_age15to19"
    "est72014sex0_age20to24"
    "est72014sex0_age25to29"
    "est72014sex0_age30to34"
    "est72014sex0_age35to39"
    "est72014sex0_age40to44"
    "est72014sex0_age45to49"
    "est72014sex0_age50to54"
    "est72014sex0_age55to59"
    "est72014sex0_age60to64"
  ]
  rows = d3.csv.parse fs.readFileSync(filename).toString()
  console.log "2014", rows.length, rows[1], Object.keys(rows[1]).filter (key) -> key.indexOf('2014') > 0
  rows.slice(1).forEach (row) ->
    fips = row["GEO.id2"];
    pop = 0
    ages.forEach (age) ->
      pop += +row[age]
    countyHash[fips].properties.pop2014 = pop


processPopulations2004 = (countyHash, filename) ->
  rows = d3.csv.parse fs.readFileSync(filename).toString()
  console.log "2004", rows.length, rows[0]
  rows.forEach (row) ->
    county = countyHash[row.STATE + "" + row.COUNTY]
    return unless county
    county.properties.pop2004 ?= 0
    if +row.AGEGRP >= 4 and +row.AGEGRP <= 13 and row.SEX == "0"
      county.properties.pop2004 += +row['POPESTIMATE2004']


processPopulations1994 = (countyHash, filename) ->
  rows = d3.tsv.parse fs.readFileSync(filename).toString()
  console.log "1994", rows.length, rows[0]
  rows.forEach (row) ->
    county = countyHash[row.FIPS]
    county.properties.pop1994 ?= 0
    # age groups
    if +row.age >= 15 and +row.age <= 64
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

processPopulations1994 countyHash, dataDir + "/Georgia-County-age-sex-1990-1999.tsv"
processPopulations2004 countyHash, dataDir + "/CO-EST00INT-AGESEX-5YR.csv"
processPopulations2014 countyHash, dataDir + "/PEP_2014_PEPAGESEX_with_ann.csv"


rows = counties.map (d) ->
  return d.properties
csv = d3.csv.format(rows)

fs.writeFileSync "../data/counties-joined.csv", csv
fs.writeFileSync "../data/us-joined.topojson", JSON.stringify us
