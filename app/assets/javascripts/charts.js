$(function() {
  var w, h, svg;
  w = 960;
  h = 600;
  svg = d3.select('vis').append('svg')
  svg.attr("width", w)
    .attr('height', h)
  var statusPieChart = dc.pieChart("#status-pie");
  d3.json("/mobile_sessions", function(json) {
    var session_lengths = json.map(function(d) {return d.session_length}),
        filtered_data = crossfilter(json),
        all = filtered_data.groupAll(),
        dimension_by_status = filtered_data.dimension(function(d) { return d.status; }),
        status_group = dimension_by_status.group(),
        status_total = dimension_by_status.groupAll().reduceCount(),
        subtype_dimension = filtered_data.dimension(function(d) {return d.last_event_type}),
        subtype_group = subtype_dimension.group(),
        subtype_total = subtype_dimension.groupAll().reduceCount();

    subtype_group.reduce(reduceAdd, reduceRemove, reduceInitial);

    statusPieChart
      .width(250).height(250)
      .colors(['#299479', '#947929'])
      .radius(100)
      .innerRadius(30)
      .dimension(dimension_by_status) 
      .group(status_group) 
      .label(function(d) { 
        var label = d.data.key;
        var count = d.data.value;
        var total = status_total.value();
        var percentage = ((count/total)*100).toFixed(1)
        return label + " (" + percentage+"%)";
      })
      .renderLabel(true)
      .title(function(d) { return d.data.key + "(" + Math.floor(d.data.value / all.value() * 100) + "%)"; })
      .renderTitle(true);

    var m = 30,
        w = 300,
        h = 400,
        n = 4,
        bar_width = (w-(2*m))/n,
        bar_spacing_factor = 0.9,
        real_width = bar_width*bar_spacing_factor,
        x = d3.scale.linear().domain([0,3]).range([m, w-m-bar_width]),
        y = d3.scale.linear().domain([0,d3.max(session_lengths)]).range([m, h])

    var bar_svg = d3.select("#bar-chart")
      .append('svg')
      .attr('class', 'bar')
    var min = bar_svg.selectAll("rect.min")
      .data(subtype_group.all())
    var max = bar_svg.selectAll("rect.max")
      .data(subtype_group.all())
    var ticks = bar_svg.selectAll('g.ticks')
      .data(subtype_group.all())
    ticks.call(drawTicks, {h: h, x: x, y: y, w: real_width})
    min.call(drawBars, {h: h, x: x, y: y, w: real_width, type: 'min'})
    max.call(drawBars, {h: h, x: x, y: y, w: real_width, type: 'max'})
    dc.renderAll();
  })

  function drawTicks(selection, opts) {
    var x_coordinate = function(d,i) {return };
    selection.enter().append('g')
        .attr('class', 'ticks')
        .attr('transform', function(d,i) {return "translate(" + (opts.x(i)+ 5) + "," + (opts.h +15) + ")"})

        .append('text')
        .text(function(d) {return (d.key.toLowerCase());})
       
  }
  function drawBars(selection, opts) {
    var color = d3.interpolateRgb("#e377c2", "#1f77b4"); 
    if (opts.type === 'min') {
      var x_coordinate = function(d,i) {return opts.x(i)};
      var opacity =0.3;
    }
    if (opts.type === 'max') {
      var x_coordinate = function(d,i) {return opts.x(i) + (opts.w/2)};
      var opacity =0.5;
    }
    selection.enter().append('rect')
        .attr('class', opts.type)
        .attr('x', x_coordinate)
        .attr('y', function(d) {return opts.h - opts.y(d.value[opts.type])})
        .attr("height", function(d) {return opts.y(d.value[opts.type])})
        .attr('width', opts.w/2)
        .style('fill', function(d,i) {return color(i)})
        .style('opacity',opacity)
        .on("mouseover", function(d) {
          $('rect.' + opts.type).tipsy({
            opacity: 0.85,
            gravity: "s",
            offset: 5,
            html: true,
            title: function() { 
              var number = this.__data__.value[opts.type];
              return opts.type +": " + roundNumber(number, 2)
            }
          });
        })
  }
  function reduceAdd(acc, d) { 
    if (d.session_length > acc["max"]) { acc["max"] = d.session_length }
    if (d.session_length < acc["min"]) { acc["min"] = d.session_length }
    return acc;
  }
  function reduceRemove(acc, d) { 
    if (d.session_length < acc["max"]) { acc["max"] = d.session_length }
    if (d.session_length > acc["min"]) { acc["min"] = d.session_length }
    return acc 
  } 
  function reduceInitial(acc, d) { 
    var acc={}; 
    acc["max"]=0;
    acc["min"]=1000000000;
    return acc
  } 
  function roundNumber(num, dec) {
    var result = Math.round(num*Math.pow(10,dec))/Math.pow(10,dec);
    return result;
  } 
});
