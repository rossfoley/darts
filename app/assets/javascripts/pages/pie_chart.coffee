$ ->
  $('.pie-chart').each ->
    category = if $(@).hasClass('points') then 'Points' else 'Marks'
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
        name: category,
        colorByPoint: true,
        data: $(@).data('chart-series')
      ]
