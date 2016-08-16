$ ->
  $('.line-chart').each ->
    categories = $(@).data('chart-categories').map (date) ->
      moment(date, 'DD/MM/YY').format('MMM DD')
    series_name = $(@).data('series-name')
    chart_series = $(@).data('chart-series').map (a) ->
      if $.type(a) is 'string'
        parseFloat(a)
      else
        a
    $(@).highcharts
      title:
        text: 'Past Performance'
      legend:
        enabled: false
      xAxis:
        categories: categories
        offset: 0
        title:
          text: 'Game Date'
      yAxis:
        min: 0
        max: 1.1 * Math.max.apply(null, chart_series)
        title:
          text: series_name
      plotOptions:
        connectNulls: true
      series: [{
        name: series_name,
        data: chart_series
      }]
