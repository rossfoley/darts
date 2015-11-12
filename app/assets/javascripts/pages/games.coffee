$ ->
  $('.pie-chart').each ->
    category = if $(@).hasClass('points') then 'Points' else 'Multipliers'
    $(@).highcharts
      chart:
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false,
        type: 'pie'
      title:
        text: "Distribution of #{category}"
      tooltip:
        pointFormat: '{series.name}: <b>{point.y:.0f} ({point.percentage:.1f}%)</b>'
      plotOptions:
        pie:
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels:
            enabled: true,
            format: '<b>{point.name}</b>: {point.y:.0f} ({point.percentage:.1f}%)</b>'
            style:
              color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
      series: [
        name: 'Multipliers',
        colorByPoint: true,
        data: $(@).data('chart-series')
      ]

  $('.line-chart').each ->
    categories = $(@).data('chart-categories').map (date) ->
      moment(date, 'DD/MM/YY').format('MMM DD')
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
        max: 1.1 * Math.max.apply(null, $(@).data('chart-series'))
        title:
          text: 'Final Score'
      plotOptions:
        connectNulls: true
      series: [{
        name: 'Final Team Score',
        data: $(@).data('chart-series')
      }]
