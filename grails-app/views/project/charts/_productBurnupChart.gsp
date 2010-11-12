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
-
- Authors:
-
- Vincent Barrier (vincent.barrier@icescrum.com)
--}%

<g:setProvider library="jquery"/>
<script src="${resource(dir:'js/jquery/jqplot/plugins', file:'jqplot.canvasTextRenderer.min.js')}" type="text/javascript"></script>
<script src="${resource(dir:'js/jquery/jqplot/plugins', file:'jqplot.canvasAxisTickRenderer.min.js')}" type="text/javascript"></script>
<script src="${resource(dir:'js/jquery/jqplot/plugins', file:'jqplot.categoryAxisRenderer.min.js')}" type="text/javascript"></script>
<script src="${resource(dir:'js/jquery/jqplot/plugins', file:'jqplot.pointLabels.min.js')}" type="text/javascript"></script>
<script src="${resource(dir:'js/jquery/jqplot/plugins', file:'jqplot.cursor.min.js')}" type="text/javascript"></script>
<is:chartView>
  <div id="productBurnup" class="chart-container">
  </div>
  <jq:jquery>
    $.jqplot.config.enablePlugins = true;
    line1 = ${all};
    line2 = ${done};

    plot1 = $.jqplot('productBurnup', [line1,line2], {
        legend:{
          show:true,
          placement:'outside',
          location:'ne',
          fontSize: '11px',
          background:'#FFFFFF',
          fontFamily:'Arial'
        },
        title:{
          text:'${message(code:"is.chart.productBurnUp.title")}',
          fontFamily:'Arial'
        },
        grid: {
          background:'#FFFFFF',
          gridLineColor:'#CCCCCC',
          shadow:false,
          borderWidth:0
        },
        seriesDefaults: {
          pointLabels:{location:'n', ypadding:2}
        },
        series:[
            {label:'${message(code:"is.chart.productBurnUp.serie.all.name")}',color: '#FFCC33'},
            {label:'${message(code:"is.chart.productBurnUp.serie.done.name")}',color: '#009900'}
            ],
        axes:{
            xaxis:{
              ticks:${labels},
              label:'${message(code:'is.chart.productBurnUp.xaxis.label')}',
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
            label:'${message(code:'is.chart.productBurnUp.yaxis.label')}',
            tickOptions:{formatString:'%d'}}
        },
        cursor: {
          show: true,
          zoom: true
        }
    });
    $('#productBurnup').bind('resize.jqplot', function(event, ui) {
        plot1.replot();
    });
  </jq:jquery>
</is:chartView>
<is:buttonBar>
  <is:button
          elementId="close"
          type="link"
          button="button-s button-s-black"
          update="window-content-${id}"
          remote="true"
          url="[controller:id,action:'dashboard',params:[product:params.product]]"
          value="${message(code: 'is.button.close')}"/>
</is:buttonBar>