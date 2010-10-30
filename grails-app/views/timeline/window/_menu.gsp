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

<%@ page import="org.icescrum.core.domain.Release" %>

<is:menuItem first="true">
  <is:link id="${release.id}"
          action="open"
          update="window-content-${id}"
          value="${message(code:'is.ui.timeline.menu.open')}"
          onclick="\$.icescrum.stopEvent(event).openWindow('releasePlan/${release.id}');"
          disabled="true"/>
</is:menuItem>

<is:menuItem rendered="${release.state == Release.STATE_WAIT && !activeRelease}" renderedOnAccess="productOwner() or scrumMaster()">
  <is:link id="${release.id}"
          action="activate"
          update="window-content-${id}"
          onclick="\$.icescrum.stopEvent(event)"
          value="${message(code:'is.ui.timeline.menu.activate')}"
          history='false'
          remote="true"/>
</is:menuItem>

<is:menuItem rendered="${release.state == Release.STATE_INPROGRESS && isClosable}" renderedOnAccess="productOwner() or scrumMaster()">
  <is:link id="${release.id}"
          action="close"
          update="window-content-${id}"
          onclick="\$.icescrum.stopEvent(event)"
          history='false'
          value="${message(code:'is.ui.timeline.menu.close')}"
          remote="true"/>
</is:menuItem>

<is:menuItem rendered="${release.state != org.icescrum.core.domain.Release.STATE_DONE}" renderedOnAccess="productOwner() or scrumMaster()">
  <is:link id="${release.id}"
          action="edit"
          update="window-content-${id}"
          onclick="\$.icescrum.stopEvent(event);"
          value="${message(code:'is.ui.timeline.menu.update')}"
          remote="true"/>
</is:menuItem>
<is:menuItem rendered="${release.state == Release.STATE_WAIT}" renderedOnAccess="productOwner() or scrumMaster()">
  <is:link id="${release.id}"
          action="delete"
          remote="true"
          update="window-content-${id}"
          history='false'
          onSuccess="\$('#window-toolbar').icescrum('toolbar').reload('${id}');"
          onclick="\$.icescrum.stopEvent(event);"
          value="${message(code:'is.ui.timeline.menu.delete')}"
          confirmBeforeSubmit="${message(code:'is.ui.timeline.menu.confirm.delete')}"/>
</is:menuItem>