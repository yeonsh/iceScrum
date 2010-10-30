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
<script src="${resource(dir:'js/jquery/jqplot/plugins', file:'jqplot.barRenderer.min.js')}" type="text/javascript"></script>
<script src="${resource(dir:'js/jquery/jqplot/plugins', file:'jqplot.categoryAxisRenderer.min.js')}" type="text/javascript"></script>
<script src="${resource(dir:'js/jquery/jqplot/plugins', file:'jqplot.canvasTextRenderer.min.js')}" type="text/javascript"></script>
<script src="${resource(dir:'js/jquery/jqplot/plugins', file:'jqplot.canvasAxisTickRenderer.min.js')}" type="text/javascript"></script>
<is:chartView>
<div id="releaseParkingLot" class="chart-container">
</div>
<jq:jquery>
  $.jqplot.config.enablePlugins = true;
  line1 = ${values};
  $.jqplot('releaseParkingLot', [line1], {
      fontFamily:'Arial',
      legend:{
        show:true,
        placement:'outside',
        location:'ne',
        fontSize: '11px',
        background:'#FFFFFF',
        fontFamily:'Arial'
      },
      title:{
        text:'${message(code:"is.chart.releaseParkingLot.title")}',
        fontFamily:'Arial'
      },
      grid: {
        background:'#FFFFFF',
        gridLineColor:'#CCCCCC',
        shadow:false,
        borderWidth:0
      },
      seriesDefaults:{
          renderer: $.jqplot.BarRenderer,
          rendererOptions:{barWidth: 50,barDirection:'horizontal', barPadding: 6, barMargin:15},
          shadowAngle:135
      },
      series:[
          {label:'${message(code:"is.chart.releaseParkingLot.serie.name")}',color: '#afe2ff'}
          ],
      axes:{
          xaxis:{
            min:0,
            max:100,
            label:'${message(code:'is.chart.releaseParkingLot.xaxis.label')}',
            tickOptions:{formatString:''}
          },
          yaxis:{
            label:'${message(code:'is.chart.releaseParkingLot.yaxis.label')}',
            renderer:$.jqplot.CategoryAxisRenderer,
            ticks:${featuresNames},
            rendererOptions:{tickRenderer:$.jqplot.CanvasAxisTickRenderer},
            tickOptions:{
                fontSize:'11px',
                fontFamily:'Arial',
                angle:30
            }
          }
      }
  });
</jq:jquery>
</is:chartView>
<is:buttonBar>
  <is:button
          targetLocation="${controllerName+'/'+params.id}"
          elementId="close"
          type="link"
          button="button-s button-s-black"
          remote="true"
          url="[controller:id, action:'index',id:params.id, params:[product:params.product]]"
          update="window-content-${id}"
          value="${message(code: 'is.button.close')}"/>
</is:buttonBar>