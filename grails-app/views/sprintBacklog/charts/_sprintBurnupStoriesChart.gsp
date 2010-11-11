%{--
  - Copyright (c) 2010 iceScrum Technologies.
  -
  - This file is part of iceScrum.
  -
  - iceScrum is free software: you can redistribute it and/or modify
  - it under the terms of the GNU Affero General Public License as published by
  - the Free Software Foundation, either version 3 of the License.
  -
  - iceScrum is distributed in the hope that it will be useful,
  - but WITHOUT ANY WARRANTY; without even the implied warranty of
  - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  - GNU General Public License for more details.
  -
  - You should have received a copy of the GNU Affero General Public License
  - along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
  --}%

<g:setProvider library="jquery"/>
<script src="${resource(dir:'js/jquery/jqplot/plugins', file:'jqplot.canvasTextRenderer.min.js')}" type="text/javascript"></script>
<script src="${resource(dir:'js/jquery/jqplot/plugins', file:'jqplot.canvasAxisTickRenderer.min.js')}" type="text/javascript"></script>
<script src="${resource(dir:'js/jquery/jqplot/plugins', file:'jqplot.categoryAxisRenderer.min.js')}" type="text/javascript"></script>
<script src="${resource(dir:'js/jquery/jqplot/plugins', file:'jqplot.cursor.min.js')}" type="text/javascript"></script>
<script src="${resource(dir:'js/jquery/jqplot/plugins', file:'jqplot.pointLabels.min.js')}" type="text/javascript"></script>
<is:chartView>
  <div id="sprintBurnupStories" class="chart-container">
  </div>
  <jq:jquery>
    $.jqplot.config.enablePlugins = true;
    line1 = ${stories};
    line2 = ${storiesDone};

    plot1 = $.jqplot('sprintBurnupStories', [line1,line2], {
        legend:{
          show:true,
          placement:'outside',
          location:'ne',
          fontSize: '11px',
          background:'#FFFFFF',
          fontFamily:'Arial'
        },
        title:{
        text:'${message(code:"is.chart.sprintBurnupStoriesChart.title")}',
          fontFamily:'Arial'
        },
        grid: {
          background:'#FFFFFF',
          gridLineColor:'#CCCCCC',
          shadow:false,
          borderWidth:0
        },
        seriesDefaults: {
          pointLabels:{location:'s', ypadding:2}
        },
        series:[
            {label:'${message(code:"is.chart.sprintBurnupStoriesChart.serie.stories.name")}',color: '#FFCC33'},
            {label:'${message(code:"is.chart.sprintBurnupStoriesChart.serie.storiesDone.name")}',color: '#009900'},
            ],
        axes:{
            xaxis:{
              min:0,
              label:'${message(code:'is.chart.sprintBurnupStoriesChart.xaxis.label')}',
              ticks:${labels},
              renderer: $.jqplot.CategoryAxisRenderer,
              rendererOptions:{tickRenderer:$.jqplot.CanvasAxisTickRenderer},
              tickOptions:{
                  fontSize:'11px',
                  fontFamily:'Arial',
                  angle:-30
              }
            },
            yaxis:{
              min:0,
              label:'${message(code:'is.chart.sprintBurnupStoriesChart.yaxis.label')}',
              tickOptions:{formatString:'%d'}
            }
        },
        cursor: {
          show: true,
          zoom: true
        }
    });
    $('#sprintBurnupStories').bind('resize.jqplot', function(event, ui) {
        plot1.replot();
    });
  </jq:jquery>
</is:chartView>
<is:buttonBar>
  <is:button
          targetLocation="${controllerName+'/'+params.id}"
          elementId="close"
          type="link"
          button="button-s button-s-black"
          update="window-content-${id}"
          remote="true"
          url="[controller:id,action:'index',params:[id:params.id,product:params.product]]"
          value="${message(code: 'is.button.close')}"/>
</is:buttonBar>