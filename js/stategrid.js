/*
Renders minimap and handles zooming to state functionality
*/
var minisvg = d3.select("#state-grid");
var miniwidth = 400;
var miniheight = 200;

var states = [];
d3.select("#grid").text().split("\n").forEach(function(line, i) {
  var re = /\w+/g, m;
  while (m = re.exec(line)) states.push({
    name: m[0],
    x: m.index / 3,
    y: i
  });
});

var gridWidth = d3.max(states, function(d) { return d.x; }) + 1;
var gridHeight = d3.max(states, function(d) { return d.y; }) + 1;
var cellSize = 25;

var state = minisvg.append("g")
    .attr("transform", "translate(" + miniwidth / 2 + "," + miniheight / 2 + ")scale(1)")
  .selectAll(".state")
    .data(states)
  .enter().append("g")
    .classed("state", true)
    .attr("transform", function(d) { return "translate(" + (d.x - gridWidth / 2) * cellSize + "," + (d.y - gridHeight / 2) * cellSize + ")"; });

state.append("rect")
  .attr("x", -cellSize / 2)
  .attr("y", -cellSize / 2)
  .attr("width", cellSize - 2)
  .attr("height", cellSize - 2);

state.append("text")
  .attr("dy", ".35em")
  .attr("dx", "-.1em")
  .text(function(d) { return d.name; });

state.on("click", function(d) {
  console.log("clicked", d)
  var sel = d3.selectAll(".state-boundary").filter(function(a) { return a.properties.code === d.name})
  var state = sel.data()[0]
  console.log("state", state)
  clicked(state);
  if(d3.select(this).classed("selected")) {
    d3.select(this).classed("selected", false)
  } else {
    minisvg.selectAll(".state").classed("selected", false)
    d3.select(this).classed("selected", true)
  }

});



function clicked(d) {
  var x, y, k;
  console.log("clicked", d)

  if (d && centered !== d) {
    var centroid = path.centroid(d);
    x = centroid[0];
    y = centroid[1];
    var bounds = path.bounds(d);
    var dx = bounds[1][0] - bounds[0][0];
    var dy = bounds[1][1] - bounds[0][1];
    k = .9 / Math.max(dx / mapwidth, dy / mapheight);
    centered = d;
  } else {
    x = mapwidth / 2;
    y = mapheight / 2;
    k = 1;
    centered = null;
  }

  mapsvg.selectAll("path.state-boundary")
      .classed("active", centered && function(d) { return d === centered; });

  mapsvg.transition()
      .duration(450)
      .attr("transform", "translate(" + mapwidth / 2 + "," + mapheight / 2 + ")scale(" + k + ")translate(" + -x + "," + -y + ")")
      .style("stroke-width", 1.5 / k + "px");

  mapsvg.selectAll("path.county")
  .transition().duration(300)
  .style("opacity", 0)
  .remove();

  var counties = [];
  geoCounties.forEach(function(c) {
    var sid = d.id+"";
    var cid = c.id+"";
    if(cid.slice(0,sid.length) === sid && cid.length - sid.length == 3) counties.push(c);
  })
  console.log("filtered counties", counties)
  var countyPaths = mapsvg
  	.selectAll("path.county")
    .data(counties)
  countyPaths
  	.enter().append("path").classed("county", true)
    .style("opacity", 0)

  countyPaths.attr("d", path)
  .transition()
  .duration(800)
  .style("opacity", 0.6)
}
