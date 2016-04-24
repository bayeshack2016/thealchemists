

fs = require 'fs'
path = require 'path'
d3 = require 'd3'
request = require 'request'
async = require 'async'

dataDir = path.join __dirname, "../data/"


processYear = (year, state) ->
  url = "https://www.ssa.gov/policy/docs/statcomps/ssi_sc/#{year}/#{state}.xlsx"
  req = {
    method: "GET",
    url: url,
    encoding: null
  }
  request.get req, (err, response, body) ->
    fs.writeFileSync dataDir + "/disability/ssi-#{year}-#{state}.xlsx", body


#d3.range(2004, 2009).forEach (year) ->
#  processYear(year + "", "01")
d3.range(2004, 2015).forEach (year) ->
  processYear(year + "", "ga")
