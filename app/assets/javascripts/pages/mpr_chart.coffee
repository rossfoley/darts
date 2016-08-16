$ ->
  $('.mpr-chart').each ->
    categories = $(@).data('chart-categories').map (date) ->
      moment(date, 'DD/MM/YY').format('MMM DD')
    series_name = $(@).data('series-name')
    player_mpr = parseFloat($(@).data('player-mpr'))
    chart_series = $(@).data('chart-series').map (a) ->
      if $.type(a) is 'string'
        parseFloat(a)
      else
        a
    mpr_start = Math.max(-0.5, chart_series.length - 25.5)
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
        plotBands: [{
          from: mpr_start,
          to: 30,
          color: 'rgba(223,240,216, 0.5)',
          label: {
            text: 'Recent MPRs'
          }
        }]
      yAxis:
        min: 0
        max: 1.1 * Math.max.apply(null, chart_series)
        title:
          text: series_name
        plotLines: [{
          value: player_mpr,
          width: 2,
          color: '#3c763d',
          dashStyle: 'shortdash',
          zIndex: 999,
          label:
            text: 'Recent MPR'
        }]
      plotOptions:
        connectNulls: true
      series: [{
        name: series_name,
        data: chart_series
      }]
