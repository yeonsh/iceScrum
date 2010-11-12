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
- Damien vitrac (damien@oocube.com)
- Manuarii Stein (manuarii.stein@icescrum.com)
- Stephane Maldini (stephane.maldini@icescrum.com)
--}%
<g:set var="productOwner" value="${sec.access([expression:'productOwner()'], {true})}"/>

%{--Add button--}%
<is:iconButton
        action="add"
        controller="${id}"
        shortcut="[key:'ctrl+n',scope:id]"
        title="${message(code:'is.ui.sandbox.toolbar.alt.new')}"
        alt="${message(code:'is.ui.sandbox.toolbar.alt.new')}"
        update="window-content-${id}"
        icon="create">
  ${message(code: 'is.ui.sandbox.toolbar.new')}
</is:iconButton>


<is:separatorSmall rendered="${productOwner}"/>

%{--Accept button--}%
<is:iconButton
        rendered="${productOwner}"
        shortcut="[key:'ctrl+shift+a',scope:id]"
        controller="${id}"
        history="false"
        disabled="true"
        onClick="${is.remoteDialogFunction(
                          title:'is.dialog.acceptStory.title',
                          action:'openDialogAcceptAs',
                          controller:id,
                          height:125,
                          width:360,
                          before:'if (\$(\'.postit.ui-selected,.table-row-focus\').icescrum(\'postit\').requestIds() == false) return false;',
                          valid:[
                              action:'accept',
                              controller:id,
                              params:'\$(\'.postit.ui-selected,.table-row-focus\').icescrum(\'postit\').requestIds()',
                              update:'window-content-'+id,
                              button:'is.dialog.acceptAs.button'
                          ])
                  }"
        alt="${message(code:'is.ui.sandbox.toolbar.alt.accept')}"
        title="${message(code:'is.ui.sandbox.toolbar.alt.accept')}">
  ${message(code: 'is.ui.sandbox.toolbar.accept')}
</is:iconButton>

<is:separatorSmall renderedOnAccess="productOwner()"/>

%{--Delete button (note-view)--}%
<is:iconButton
        icon="delete"
        rendered="${productOwner}"
        action="delete"
        shortcut="[key:'del',scope:id]"
        controller="${id}"
        onclick="\$.icescrum.selectableAction();"
        disablable="true"
        disabled="true"
        confirmBeforeSubmit="${message(code:'is.ui.sandbox.toolbar.delete.confirmation')}"
        alt="${message(code:'is.ui.sandbox.toolbar.alt.delete')}"
        title="${message(code:'is.ui.sandbox.toolbar.alt.delete')}">
  ${message(code: 'is.ui.sandbox.toolbar.delete')}
</is:iconButton>

<is:separator/>

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

%{--Xml stories importer
<sec:ifLoggedIn>
  <is:iconButton
          action="uploadStoriesPanel"
          controller="sandbox"
          alt="${message(code:'is.ui.sandbox.toolbar.alt.import')}"
          title="${message(code:'is.ui.sandbox.toolbar.alt.import')}">
    ${message(code: 'is.ui.sandbox.toolbar.import')}
  </is:iconButton>

  <is:separator/>
</sec:ifLoggedIn>
                --}%
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

%{--Textfield for the auto completion search--}%
<is:panelSearch id="search-ui">
  <is:autoCompleteSearch elementId="autoCmpTxt" controller="${id}" action="list" update="window-content-${id}"/>
</is:panelSearch>
