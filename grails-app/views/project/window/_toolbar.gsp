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
- Manuarii Stein (manuarii.stein@icescrum.com)
- Stephane Maldini (manuarii.stein@icescrum.com)
--}%

<is:panelButton alt="Charts" id="menu-chart" arrow="true" icon="graph" text="${message(code:'is.ui.toolbar.charts')}">
  <ul>
    <li class="first">
      <is:link
              action="productCumulativeFlowChart"
              controller="${id}"
              update="window-content-${id}"
              title="${message(code:'is.ui.project.charts.productCumulativeFlow')}"
              remote="true"
              value="${message(code:'is.ui.project.charts.productCumulativeFlow')}"/>
    </li>
    <li>
      <is:link
              action="productBurnupChart"
              controller="${id}"
              update="window-content-${id}"
              title="${message(code:'is.ui.project.charts.productBurnup')}"
              remote="true"
              value="${message(code:'is.ui.project.charts.productBurnup')}"/>
    </li>
    <li>
      <is:link
              action="productBurndownChart"
              controller="${id}"
              update="window-content-${id}"
              title="${message(code:'is.ui.project.charts.productBurndown')}"
              remote="true"
              value="${message(code:'is.ui.project.charts.productBurndown')}"/>
    </li>
    <li>
      <is:link
              action="productParkingLotChart"
              controller="${id}"
              params="['referrer.action':'dashboard','referrer.controller':id]"
              update="window-content-${id}"
              title="${message(code:'is.ui.project.charts.productParkingLot')}"
              remote="true"
              value="${message(code:'is.ui.project.charts.productParkingLot')}"/>
    </li>
    <li>
      <is:link
              action="productVelocityChart"
              controller="${id}"
              update="window-content-${id}"
              title="${message(code:'is.ui.project.charts.productVelocity')}"
              remote="true"
              value="${message(code:'is.ui.project.charts.productVelocity')}"/>
    </li>
    <li class="last">
      <is:link
              action="productVelocityCapacityChart"
              controller="${id}"
              update="window-content-${id}"
              title="${message(code:'is.ui.project.charts.productVelocityCapacity')}"
              remote="true"
              value="${message(code:'is.ui.project.charts.productVelocityCapacity')}"/>
    </li>
  </ul>
</is:panelButton>

<is:separator/>

%{--Print button--}%
<is:reportPanel
        action="print"
        text="${message(code: 'is.ui.toolbar.print')}"
        formats="[
                  ['PDF', message(code:'is.report.format.pdf')],
                  ['RTF', message(code:'is.report.format.rtf')],
                  ['DOCX', message(code:'is.report.format.docx')],
                  ['ODT', message(code:'is.report.format.odt')]
                ]"
        params="locationHash='+encodeURIComponent(\$.icescrum.o.currentOpenedWindow.context.location.hash)+'"/>