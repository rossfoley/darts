$ ->
  $('.column-chart').each ->
    $(@).highcharts
      chart:
        type: 'column'
      title:
        text: 'Mark Distribution'
      xAxis:
        categories: ['Singles', 'Doubles', 'Triples']
        crosshair: true
      yAxis:
        min: 0
        title:
          text: 'Throws'
      tooltip:
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>'
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
          '<td style="padding:0"><b>{point.y:.0f} throws</b></td></tr>'
        footerFormat: '</table>'
        shared: true
        useHTML: true
      series: $(@).data('chart-series')
