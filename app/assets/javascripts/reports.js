var reports = {}

reports.control = {
  menu: function(){
    $('.subject-menu-single').fadeOut(300);
    $('.report-menu').children('.ul').children('li').click(function(){
      var item = '#' + $(this).data('item');

      // console.log('Item: ' + item);

      $(this).parent('.ul').find('li').addClass('deactive');
      $(this).removeClass('deactive');

      $(item).closest('.report-item').siblings().fadeOut(300, function(){
        $(item).closest('.report-item').delay(300).fadeIn();
      });
        // reports.charts.signupGender();

      if ( $(item).hasClass('with-sub-items') ) {
        $(item).parents('.subjects-charts:first').find('.with-sub-items').addClass('hidden');
        $(item).removeClass('hidden');
      };

      if ( item == '#participation-subject') {
        $(item).find('.participation-subject').addClass('hidden');
        $(item).find('.participation-subject:first').removeClass('hidden');
      };

      // Subject Menu do #participation-subject
      if ( item === '#participation-subject' && !$(this).hasClass('deactive') ){
          $('.subject-menu-single').delay(300).fadeIn(300);
      }
      else if (item === '#participation-signup' || item === '#participation-debate'){
        $('.subject-menu-single').fadeOut(300);
      }
    });
  },

  subjectMenu: function(){
    // var size = 450;
    var item = 0,
        item_active = 1,
        arr = '';
        data= '';

    $('.subject-menu i').click(function(e){

      arr = $(this).siblings('.subject-holder').find('li');
      item_active = $(this).siblings('.subject-holder').find('li.active').length;


      // console.log('ITEM ATIVO: ' + item_active);

      if ( $(this).hasClass('arrow-right') ){

        if ( item_active < arr.length - 1) {

          if ( item_active === 0 ){
            item = 0;
           }

          $(arr[item]).addClass('active');
          item += 1;
          // console.log('ITEM +');
        }

      } else {
        $(arr[item-1]).removeClass('active');
        item -= 1;
        // console.log('ITEM -: ' + item);
      }

      data = $(this).siblings('.subject-holder').find('li').not('.active');
      data = $(data[0]).data('target');
      $('.participation-subject').addClass('hidden');
      $(data).removeClass('hidden');
      if (item < 0) {
        item = 0
      };


      if (item != item_active) {
        $('.subjects-charts').find('.with-sub-items').each(function(){
          $(this).find('.report-item.active').removeClass('active')
          $(this).find('.report-item').eq(item).addClass('active')
        })
      };
    });
  },

  init:function(){
    this.menu();
    this.subjectMenu();
  }
}

reports.theme = {
  baseTheme: function(){
    Highcharts.theme = {
      colors: ['#37508900', '#3D3B6D', '#0073B4', '#4EA5DB', '#8CCBF6'],
      title: {
          style: {
              color: '#3D3C6D',
              font: '16px "Merriweather Sans", sans-serif'
          },
          margin: 20,
          y: 20
      },
      subtitle: {
          style: {
              color: '#3D3C6D',
              font: '12px "Merriweather Sans", sans-serif'
          }
      },

      legend: {
          itemStyle: {
              font: '16px "Merriweather Sans", sans-serif',
              color: '#3D3C6D'
          },
          align: 'left',
          y: 20,
          margin: 60,
          itemDistance: 30,
          itemMarginBottom: 15,
          symbolHeight: 16,
          symbolWidth: 16,
          symbolRadius: 12
      },
      plotOptions: {
          pie: {
              size: '100%'
          },
          series: {
            dataLabels:{
                align: 'left',
                x: 2,
                y: -4,
              style: {
                  font: '16px "Merriweather Sans", sans-serif',
                  color: '#3D3C6D'
              }
            }
          }
      },
      credits: {
          enabled: false
      }
    };
    Highcharts.setOptions(Highcharts.theme);
  },

  init: function(){
    this.baseTheme();
  }
},

reports.charts = {
  setChart: function(id, type, title, series, percentage, legend, colors) {
    if (colors == undefined || colors == 'undefined') {
      colors = ['#375089', '#3D3B6D', '#0073B4', '#4EA5DB', '#8CCBF6']
    };

    // if (percentage) {
    //   pointFormat = '{series.name}: <b>{point.percentage:.1f}%</b>'
    // } else {
    //   pointFormat = '{series.name}: <b>{point.y}</b>'
    // };

    pointFormat = '{series.name}:<br/><b>{point.percentage:.1f}%</b><br/><b>{point.y}</b>'

    if (type == 'pie') {
      chart = {
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false,
        type: type
      }

      plotOptions = {
        pie: {
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: false
          },
          showInLegend: legend
        }
      }

      tooltip = {
        pointFormat: pointFormat
      }
    } else if (type == 'pie-multiple') {
      chart = {
        type: 'pie'
      }

      plotOptions = {
        pie: {
          shadow: false,
          center: ['50%', '50%'],
          dataLabels: {
            enabled: false
          },
          showInLegend: legend
        }
      }

      tooltip = {
        formatter: function () {

          if (this.series.data.indexOf(this.point) === 0){
            // if (percentage) {
            //   pointFormat = this.series.name + ": <b>" + this.percentage + "%</b>";
            // } else {
            //   pointFormat = this.series.name + ": <b>" + this.y + "</b>";
            // };

            // return pointFormat
            return (this.series.name + ":<br/><b>" + this.percentage.toFixed(2) + "%</b><br/><b>" + this.point.y + '</b>')
          }

          return false
        },
        hideDelay: 200
      }
    };

    $(id).highcharts({
      colors: colors,
      chart: chart,
      title: {
        text: title,
        margin: 30
      },
      tooltip: tooltip,
      plotOptions: plotOptions,
      series: series
    })
  },

  signupAge: function(series, colors){

    if (colors == undefined || colors == 'undefined') {
      colors = ['#375089', '#3D3B6D', '#0073B4', '#4EA5DB', '#8CCBF6']
    };

    var info = [7,12,16,32,64,55,23];
    var dataSum = 0;

    for (var i=0;i < info.length;i++) {
        dataSum += info[i]
    }

    var chart = new Highcharts.Chart({
      // colors: ['#F86048'],
      colors: colors,
      chart: {
          renderTo: 'signup-age',
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false,
          type: 'bar'
      },
      title: {
          text: 'Cadastros por idade',
          margin: 30
      },
      tooltip: {
          // var pcnt = (this.y / dataSum) * 100;
          // pcnt = pcnt.toFixed(0);
          pointFormat: 'Quantidade: <b>{point.y} Pessoas</b> '
          // pointFormat: 'Quantidade:<br/><b>{point.percentage}%</b><br/><b>{point.y}</b>'
      },
      legend: {
          enabled: false
      },
      xAxis: {
          categories: [],
          gridLineWidth: 0,
          lineWidth: 0,
          minorGridLineWidth: 0,
          lineColor: 'transparent',
          minorGridLineWidth: 0,
          minorTickLength: 0,
          tickLength: 0,
      },
      yAxis: {
          title: {
              enabled: false
              },
          gridLineWidth: 0,
          minorGridLineWidth: 0,
          lineWidth: 0,
          minorGridLineWidth: 0,
          lineColor: 'transparent',
          labels: {
              enabled: false
          },
          minorTickLength: 0,
          tickLength: 0,
      },
      plotOptions: {
        series: {
            pointWidth: 28, //width of the column bars irrespective of the chart size
            dataLabels: {
                enabled: true,
                formatter:function() {
                  var pcnt = (this.y / dataSum) * 100;
                  pcnt = pcnt.toFixed(0);
                  // console.log(pcnt);
                  // return Highcharts.numberFormat(pcnt) + '%';
                  return '<b>'+ pcnt + '</b>' + '%';
                }
            }
        }
      },
      series: series
    }, function(chartObj) {
        $.each(chartObj.series[0].data, function(i, point) {
           point.dataLabel.attr({x:490});
        });
    });
  },

  subjectLikes: function(id, title, series){
    $(id).highcharts({

      // colors: ['#3E3C6D', '#511549', '#C71D38', '#247A9D', '#921340'],
      chart: {
          type: 'line'
      },
      title: {
          text: title
      },
      // subtitle: {
      //     text: 'Demo of image marker width and height'
      // },
       xAxis: {
          categories: [],
          tickPixelInterval: 10,
          gridLineWidth: 0,
          lineWidth: 0,
          minorGridLineWidth: 0,
          lineColor: 'transparent',
          minorGridLineWidth: 0,
          minorTickLength: 0,
          tickLength: 0,
          labels: {
              enabled: false
          }
      },
      yAxis: {
          title: {
              enabled: false
              },
          gridLineWidth: 0,
          minorGridLineWidth: 0,
          lineWidth: 0,
          minorGridLineWidth: 0,
          lineColor: 'transparent',
          labels: {
              enabled: false
          },
          minorTickLength: 0,
          tickLength: 0,
          tickInterval: 1
      },
      // tooltip: {
      //     crosshairs: true,
      //     shared: true
      // },
      legend: {
          align: 'center',
          symbolPadding: 20,
          symbolWidth: 5,
          symbolRadius: 0
      },
      series: series
    });
  },

  // Last Report row
  setAnonymous: function(id, title, series, colors){
    if (colors == undefined || colors == 'undefined') {
      colors = ['#375089', '#3D3B6D', '#0073B4', '#4EA5DB', '#8CCBF6']
    };

    $(id).highcharts({
      colors: colors,
      chart: {
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false,
          type: 'pie',
          backgroundColor:'rgba(255, 255, 255, 0.1)'
      },
      title: {
          text: title
      },
      tooltip: {
          formatter: function() {
            // return '<b>'+ this.point.name +'</b>: '+ this.percentage.toFixed(2) +' %';
            return (this.point.name + ":<br/><b>" + this.percentage.toFixed(2) + "%</b><br/><b>" + this.point.y + '</b>')
          }
      },
      legend: {
          enabled:true
      },
      plotOptions: {
          pie: {
              allowPointSelect: true,
              cursor: 'pointer',
              size: 250,
              dataLabels: {
                  enabled: false
              }
          }
      },
      series: series
      },function(chart) {

        $(chart.series[0].data).each(function(i, e) {
            e.legendItem.on('click', function(event) {
                var legendItem=e.name;
                event.stopPropagation();

                $(chart.series).each(function(j,f){
                    $(this.data).each(function(k,z){
                        if(z.name==legendItem){
                           if(z.visible) {
                              z.setVisible(false);
                           }
                           else {
                              z.setVisible(true);
                           }
                        }
                    });
                });
            });
        });
    });
  },
  participationSubject: function(){

    $('#participation-subject').highcharts({
      chart: {
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false,
          type: 'pie',
          backgroundColor:'rgba(255, 255, 255, 0.1)'
      },
      title: {
          text: 'Identificados x Anônimos'
      },
      tooltip: {
          formatter: function() {
              return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
          }
      },
      legend: {
          enabled:true
      },
      plotOptions: {
          pie: {
              allowPointSelect: true,
              cursor: 'pointer',
              size: 250,
              dataLabels: {
                  enabled: false
              }
          }
      },
      series: [{
          name: 'Identificados',
          colorByPoint: true,
          innerSize: '45%',
          center: [110, 120],
          showInLegend: true,
          data: [{
              name: 'Cidadão',
              y: 56.33
          }, {
              name: 'Setor Público',
              y: 24.03
          }, {
              name: 'Organização Social e Civil',
              y: 10.38
          }, {
              name: 'Segurança Pública',
              y: 4.77
          }, {
              name: 'Educação',
              y: 0.91
          }]
        },{
          name: 'Anônimos',
          colorByPoint: true,
          innerSize: '42%',
          center: [400, 120],
          showInLegend: false,
          data: [{
              name: 'Cidadão',
              y: 56.33
          }, {
              name: 'Setor Público',
              y: 24.03
          }, {
              name: 'Organização Social e Civil',
              y: 10.38
          }, {
              name: 'Segurança Pública',
              y: 4.77
          }, {
              name: 'Educação',
              y: 0.91
          }]
        }]
      },function(chart) {

        $(chart.series[0].data).each(function(i, e) {
            e.legendItem.on('click', function(event) {
                var legendItem=e.name;
                event.stopPropagation();

                $(chart.series).each(function(j,f){
                    $(this.data).each(function(k,z){
                        if(z.name==legendItem){
                           if(z.visible) {
                              z.setVisible(false);
                           }
                           else {
                              z.setVisible(true);
                           }
                        }
                    });
                });
            });
        });
    });
  },
  participationDebate: function(){

    $('#participation-debate').highcharts({
      chart: {
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false,
          type: 'pie',
          backgroundColor:'rgba(255, 255, 255, 0.1)'
      },
      title: {
          text: 'Identificados x Anônimos'
      },
      tooltip: {
          formatter: function() {
              return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
          }
      },
      legend: {
          enabled:true
      },
      plotOptions: {
          pie: {
              allowPointSelect: true,
              cursor: 'pointer',
              size: 250,
              dataLabels: {
                  enabled: false
              }
          }
      },
      series: [{
          name: 'Identificados',
          colorByPoint: true,
          innerSize: '45%',
          center: [110, 120],
          showInLegend: true,
          data: [{
              name: 'Cidadão',
              y: 56.33
          }, {
              name: 'Setor Público',
              y: 24.03
          }, {
              name: 'Organização Social e Civil',
              y: 10.38
          }, {
              name: 'Segurança Pública',
              y: 4.77
          }, {
              name: 'Educação',
              y: 0.91
          }]
        },{
          name: 'Anônimos',
          colorByPoint: true,
          innerSize: '42%',
          center: [400, 120],
          showInLegend: false,
          data: [{
              name: 'Cidadão',
              y: 56.33
          }, {
              name: 'Setor Público',
              y: 24.03
          }, {
              name: 'Organização Social e Civil',
              y: 10.38
          }, {
              name: 'Segurança Pública',
              y: 4.77
          }, {
              name: 'Educação',
              y: 0.91
          }]
        }]
      },function(chart) {

        $(chart.series[0].data).each(function(i, e) {
            e.legendItem.on('click', function(event) {
                var legendItem=e.name;
                event.stopPropagation();

                $(chart.series).each(function(j,f){
                    $(this.data).each(function(k,z){
                        if(z.name==legendItem){
                           if(z.visible) {
                              z.setVisible(false);
                           }
                           else {
                              z.setVisible(true);
                           }
                        }
                    });
                });
            });
        });
    });
  },

  init: function(){
    this.signupSector();
    this.signupGender();
    this.signupAge();
    this.signupRegion();
    this.subjectComment();
    this.subjectPerson();
    this.subjectLikes();
    this.subjectSector();
    this.participationSignup();
    this.participationSubject();
    this.participationDebate();
  }
},

reports.init = function() {
  reports.control.init();
  reports.theme.init();
  // reports.charts.init();
}
