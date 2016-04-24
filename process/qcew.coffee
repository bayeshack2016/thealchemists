
fs = require 'fs'
path = require 'path'
d3 = require 'd3'
request = require 'request'
async = require 'async'

dataDir = path.join __dirname, "../data/"

counties = d3.csv.parse(fs.readFileSync(dataDir + "counties-joined.csv").toString())
countyHash = {}
counties.forEach (county) ->
  countyHash[county.id] = county; # string id is FIPS code: STXXX eg 13000 wher ST is state fips code

# these two 120mb zip files have all the county data we want
# http://www.bls.gov/cew/data/files/2004/csv/2004_annual_by_area.zip
# http://www.bls.gov/cew/data/files/2014/csv/2014_annual_by_area.zip
# unzip them and put them in the data folders like
#    data/2004.annual.by_area
#    data/2014.annual.by_area

processYear = (year) ->
  keysOfInterest = [
    'annual_avg_estabs_count'
    'annual_avg_emplvl'
    'total_annual_wages'
    'taxable_annual_wages'
    'annual_avg_wkly_wage'
    'annual_contributions'
  ]
  yearDir = dataDir + "#{year}.annual.by_area"
  filelist = fs.readdirSync yearDir
  #console.log "file list", filelist
  filelist.forEach (filename) ->
    split = filename.split ' '
    countyId = split[1]
    county = countyHash[countyId]
    return unless county
    rows = d3.csv.parse fs.readFileSync(yearDir + "/" + filename).toString()
    console.log countyId#, rows[0]
    rows.forEach (row) ->
      # TODO: filter down to just agg level and industries we may care about
      # for now, just use totals
      return unless row.agglvl_code == '70'
      for key in keysOfInterest
        county[key + year] = row[key]


processYear('2004')
processYear('2014')


csv = d3.csv.format(counties)
fs.writeFileSync "../data/counties-joined.csv", csv
