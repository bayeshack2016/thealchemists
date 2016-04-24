fs = require 'fs'
path = require 'path'
d3 = require 'd3'
_ = require 'lodash'

# TODO: make this not georgia specific
dataDir = path.join __dirname, "../data/ga"

loadTopo = (filename) ->
  json = JSON.parse(fs.readFileSync(filename).toString())
  return json


processPopulations2010s = (year, filename) ->
  countyHash = {}
  counties.forEach (county) ->
    countyHash[county.properties.id] = _.clone(county); # string FIPS code: STXXX eg 13000 wher ST is state fips code
  ages = [
    "est7#{year}sex0_age15to19"
    "est7#{year}sex0_age20to24"
    "est7#{year}sex0_age25to29"
    "est7#{year}sex0_age30to34"
    "est7#{year}sex0_age35to39"
    "est7#{year}sex0_age40to44"
    "est7#{year}sex0_age45to49"
    "est7#{year}sex0_age50to54"
    "est7#{year}sex0_age55to59"
    "est7#{year}sex0_age60to64"
  ]
  rows = d3.csv.parse fs.readFileSync(filename).toString()
  console.log "2010s", year, rows.length, rows[1], Object.keys(rows[1]).filter (key) -> key.indexOf('2014') > 0
  rows.slice(1).forEach (row) ->
    fips = row["GEO.id2"];
    pop = 0
    ages.forEach (age) ->
      pop += +row[age]
    countyHash[fips].properties.pop = pop
  rows = Object.keys(countyHash).map (fips) ->
    return countyHash[fips].properties
  fs.writeFileSync dataDir + "counties-joined-#{year}.csv", d3.csv.format(rows)


processPopulations2000s = (year, filename) ->
  countyHash = {}
  counties.forEach (county) ->
    countyHash[county.properties.id] = _.clone(county); # string FIPS code: STXXX eg 13000 wher ST is state fips code
  rows = d3.csv.parse fs.readFileSync(filename).toString()
  console.log "2000s", year, rows.length, rows[0]
  rows.forEach (row) ->
    county = countyHash[row.STATE + "" + row.COUNTY]
    return unless county
    county.properties.pop ?= 0
    if +row.AGEGRP >= 4 and +row.AGEGRP <= 13 and row.SEX == "0"
      county.properties.pop += +row["POPESTIMATE#{year}"]
  rows = Object.keys(countyHash).map (fips) ->
    return countyHash[fips].properties
  fs.writeFileSync dataDir + "counties-joined-#{year}.csv", d3.csv.format(rows)

###
processPopulations1994 = (countyHash, filename) ->
  rows = d3.tsv.parse fs.readFileSync(filename).toString()
  console.log "1994", rows.length, rows[0]
  rows.forEach (row) ->
    county = countyHash[row.FIPS]
    county.properties.pop1994 ?= 0
    # age groups
    if +row.age >= 15 and +row.age <= 64
      county.properties.pop1994 += +row['1994']
###


us = loadTopo dataDir + "us-named.topojson"
counties = us.objects.counties.geometries
  # we just export georgia for now
  .filter (d) ->
    return false if !d.properties
    # return true # all states
    return d.properties.id.slice(0, 2) == "13"

console.log "counties", counties.length

#processPopulations1994 countyHash, dataDir + "/Georgia-County-age-sex-1990-1999.tsv"
#processPopulations2000s '2000', dataDir + "/CO-EST00INT-AGESEX-5YR.csv"
#processPopulations2000s '2004', dataDir + "/CO-EST00INT-AGESEX-5YR.csv"

d3.range(2004, 2010).forEach (year) ->
  processPopulations2000s year + "", dataDir + "/CO-EST00INT-AGESEX-5YR.csv"

d3.range(2010, 2015).forEach (year) ->
  processPopulations2010s year + "", dataDir + "/PEP_2014_PEPAGESEX_with_ann.csv"
