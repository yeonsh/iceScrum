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

<g:set var="productOwner" value="${sec.access([expression:'productOwner()'], {true})}"/>


%{--New--}%
  <is:iconButton
          controller="feature"
          action="add"
          rendered="${productOwner}"
          shortcut="[key:'ctrl+n',scope:id]"
          update="window-content-${id}"
          icon="create"
          alt="${message(code:'is.ui.feature.toolbar.alt.new')}"
          title="${message(code:'is.ui.feature.toolbar.alt.new')}">
    <g:message code="is.ui.feature.toolbar.new"/>
  </is:iconButton>

  <is:separatorSmall rendered="${productOwner}"/>

%{--Delete button (note-view)--}%
  <is:iconButton
          icon="delete"
          onclick="\$.icescrum.selectableAction();"
          history='false'
          rendered="${productOwner}"
          shortcut="[key:'del',scope:id]"
          disabled="true"
          disablable="true"
          confirmBeforeSubmit="${message(code:'is.ui.feature.toolbar.delete.confirmation')}"
          title="${message(code:'is.ui.feature.toolbar.alt.delete')}"
          alt="${message(code:'is.ui.feature.toolbar.alt.delete')}">
    <g:message code="is.ui.sandbox.toolbar.delete"/>
  </is:iconButton>

  <is:separator rendered="${productOwner}"/>

%{--View--}%
<is:panelButton alt="View" id="menu-display" arrow="true" icon="view" text="${message(code:'is.view.'+currentView)}">
  <ul>
    <li class="first">
      <is:link
              controller="scrumOS"
              action="changeView"
              params="'product=${params.product}&view=postitsView&window=${id}&actionWindow=list&term='+\$(\'#autoCmpTxt\').val()"
              history="false"
              update="window-content-${id}"
              remote="true"
              onSuccess="\$.icescrum.displayView('${message(code:'is.view.postitsView')}')"
              value="${message(code:'is.view.postitsView')}"/>
    </li>
    <li class="last">
      <is:link controller="scrumOS"
              action="changeView"
              params="'product=${params.product}&view=tableView&window=${id}&actionWindow=list&term='+\$(\'#autoCmpTxt\').val()"
              update="window-content-${id}"
              history="false"
              onSuccess="\$.icescrum.displayView('${message(code:'is.view.tableView')}')"
              remote="true"
              value="${message(code:'is.view.tableView')}"/>
    </li>
  </ul>
</is:panelButton>

<is:separator/>

<is:panelButton alt="Charts" id="menu-chart" arrow="true" icon="graph" text="${message(code:'is.ui.toolbar.charts')}">
  <ul>
    <li class="first">
      <is:link
              action="productParkingLotChart"
              controller="feature"
              update="window-content-${id}"
              title="${message(code:'is.ui.feature.charts.productParkingLot')}"
              remote="true"
              value="${message(code:'is.ui.feature.charts.productParkingLot')}"/>
    </li>
  </ul>
</is:panelButton>

<is:separatorSmall/>

%{--Print button--}%
<is:reportPanel
        action="print"
        text="${message(code: 'is.ui.toolbar.print')}"
        formats="[
                  ['PDF', message(code:'is.report.format.pdf')],
                  ['RTF', message(code:'is.report.format.rtf')],
                  ['DOCX', message(code:'is.report.format.docx')],
                  ['ODT', message(code:'is.report.format.odt')]
                ]"/>

%{--Search--}%
<is:panelSearch id="search-ui">
  <is:autoCompleteSearch elementId="autoCmpTxt" controller="feature" action="list" update="window-content-${id}"/>
</is:panelSearch>
