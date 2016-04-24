The Alchemists
==============
An exploration of labor force metrics changing over time at the county level.

## Visualizations

![single year](http://bayeshack2016.github.io/thealchemists/img/georgia.gif)  
### [Single Year: Georgia 2004](http://bayeshack2016.github.io/thealchemists/georgia.html)  
Investigate differences between counties for a single year of data. An alternative "bubble chart" is used to give
a sense of proportionality for counties that have high rates of unemployment
but have a very small population.

----------

![multiple years](http://bayeshack2016.github.io/thealchemists/img/georgia-gapminder.gif)  
### [Multiple years: Georgia 2004 - 2014](http://bayeshack2016.github.io/thealchemists/georgia-gapminder.html)  
Quickly see the same visualizations as the one above for the years 2004 through 2014. You can clearly see the effect of the 2008-2009 recession as the unemployment rate is color on an absolute scale.

----------

![compare 2 years](http://bayeshack2016.github.io/thealchemists/img/georgia-2004-2014.png)  
### [Compare two years: Georgia from 2004 to 2014](http://bayeshack2016.github.io/thealchemists/georgia-2004-2014.html)  
Compare two years with each other directly, by taking the difference of each metric (unemployment rate, establishments and average weekly wage) and rendering the difference.

----------

### Further work

With more time we would like to:
  * explore similar techniques for showing all the counties at once.  
  * investigate SSI disability claims alongside labor metrics
  * investigate more granular wage and establishment data (breaking down by industry at various aggregation levels)
  * explore more visualization types, particularly the [commet chart](http://bl.ocks.org/zanarmstrong/6b9277e3a06679010358) for showing changes in aggregate statistics over time
  * explore rural vs. metropolitan changes (town populations declining http://blockbuilder.org/enjalot/fe88df78ff6982c11cb92002b7410d84)


### Methodology  

We chose to focus on exploring available data at the county level as it is the most granular and consistent  spatial data across the agencies we are interested in comparing (BLS, Census, SSI). An interesting problem given the time constraints was the overwhelming amount of quality data from BLS, we spent a good bit of time narrowing down what we would try to extract and use. This was a nice challenge given that usually at least 50% of the work is cleaning data (this was still the case with Census and SSI unfortunately).

We downloaded and investigated the below data sources. We wrote [python scripts](https://github.com/bayeshack2016/thealchemists/blob/master/converter.ipynb)
in Jupyter and pandas to process some excel files. We also wrote some [node.js scripts](https://github.com/bayeshack2016/thealchemists/tree/master/process) to download and manipulate some data. It should be noted that there was a good deal of manual investigation into making sense of the various data sets and making sure we could get the same fidelity data across different years and agencies.

The visulizations were created in [d3.js](http://d3js.org) with the help of the [d3 parallel coordinates library](https://syntagmatic.github.io/parallel-coordinates/).

## Data Sources

### BLS LAU  
[Labor force data by county](http://www.bls.gov/lau/home.htm#cntyaa)

## BLS QCEW  
[Quarterly Census of Employment and Wages](http://www.bls.gov/cew/cewover.htm)  
[Directory of downloads per year](http://www.bls.gov/cew/datatoc.htm)  
[Data slices by county and year](http://www.bls.gov/cew/doc/access/csv_data_slices.htm#ANNUAL_LAYOUT)  
[BLS Area codes (FIPS)](http://www.bls.gov/cew/doc/titles/area/area_titles.htm)  

## BLS GPS  
[Geographic Profile of Employment and Unemployment](http://www.bls.gov/gps/home.htm)

## Social Security  
[SSI recipients by county](https://www.ssa.gov/policy/docs/statcomps/ssi_sc/index.html)

## US Atlas  
[counties and state geography in topojson format](https://github.com/mbostock/us-atlas)


### Census (population estimates)
#### 1990-1999:
https://www.census.gov/popest/data/counties/asrh/1990s/CO-99-09.html

#### 2000-2010
https://www.census.gov/popest/data/intercensal/county/county2010.html

#### 2010-2014
PEP_2014_PEPAGESEX
http://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=PEP_2015_PEPANNRES&src=pt


## Team
------
@enjalot - [twitter](https://twitter.com/enjalot)
@lewis500 - [twitter](https://twitter.com/lewislehe)
@siumei - [linkedin](https://www.linkedin.com/in/siumeiman)
@syntagmatic - [twitter](https://twitter.com/syntagmatic)
