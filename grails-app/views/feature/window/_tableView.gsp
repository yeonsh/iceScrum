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
<%@ page import="org.icescrum.core.domain.Story" %>
<is:tableView>
  <is:table id="feature-table"
          editable="[controller:id,action:'update',params:[product:params.product],onExitCell:'submit']">

    <is:tableHeader width="3%" class="table-cell-checkbox" name="">
      <g:checkBox/>
    </is:tableHeader>
    <is:tableHeader width="3%" name="" />
    <is:tableHeader width="4%" name="${message(code:'is.feature.rank')}"/>
    <is:tableHeader width="4%" name="${message(code:'is.feature.value')}"/>
    <is:tableHeader width="10%" name="${message(code:'is.feature.type')}"/>
    <is:tableHeader width="15%" name="${message(code:'is.feature')}"/>
    <is:tableHeader width="30%" name="${message(code:'is.backlogelement.description')}"/>
    <is:tableHeader width="5%" name="${message(code:'is.feature.effort')}"/>
    <is:tableHeader width="11%" name="${message(code:'is.feature.stories')}"/>
    <is:tableHeader width="15%" name="${message(code:'is.feature.stories.finish')}"/>

    <g:set var="productOwner" value="${sec.access([expression:'productOwner()'], {true})}"/>

    <is:tableRows in="${features}" var="feature" elemID="id">
      <is:tableColumn class="table-cell-checkbox">
        <g:checkBox name="check-${feature.id}" />
      </is:tableColumn>
      <is:tableColumn class="table-cell-postit-icon">
        <is:postitIcon color="${feature.color}" />
      </is:tableColumn>
      <is:tableColumn editable="[type:'selectui',id:'rank',name:'rank',values:rankSelect,disabled:!productOwner]">${feature.rank}</is:tableColumn>
      <is:tableColumn editable="[type:'selectui',disabled:!productOwner,name:'value',values:suiteSelect]">${feature.value}</is:tableColumn>
      <is:tableColumn editable="[type:'selectui',id:'type',disabled:!productOwner,name:'type',values:typeSelect]"><is:bundleFromController bundle="typesBundle" value="${feature.type}"/></is:tableColumn>
      <is:tableColumn editable="[type:'text',disabled:!productOwner,name:'name']">${feature.name.encodeAsHTML()}</is:tableColumn>
      <is:tableColumn editable="[type:'textarea',disabled:!productOwner,name:'description']">${feature.description?.encodeAsHTML()}</is:tableColumn>
      <is:tableColumn>${effortFeature(feature)}</is:tableColumn>
      <is:tableColumn>${feature.stories?.size() ?: 0}</is:tableColumn>
      <is:tableColumn>${linkedDoneStories(feature)}</is:tableColumn>
    </is:tableRows>
  </is:table>
</is:tableView>
<jq:jquery>
  jQuery("#window-content-${id}").removeClass('window-content-toolbar');
  if(!jQuery("#dropmenu").is(':visible')){
    jQuery("#window-id-${id}").focus();
  }
  <is:renderNotice />
  <icep:notifications
        name="${id}Window"
        reload="[update:'#window-content-'+id,action:'list',params:[product:params.product]]"
        disabled="!jQuery('#backlog-layout-window-${id}, .view-table').is(':hidden')"
        group="${params.product}-${id}"
        listenOn="#window-content-${id}"/>
</jq:jquery>