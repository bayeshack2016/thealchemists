

fs = require 'fs'
path = require 'path'
d3 = require 'd3'
request = require 'request'
async = require 'async'

dataDir = path.join __dirname, "../data/"


processYear = (year) ->
  https://www.ssa.gov/policy/docs/statcomps/ssi_sc/2014/table03alt.xlsx
  request.get url, (err, response, body) ->
