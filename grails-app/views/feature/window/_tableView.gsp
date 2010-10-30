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

<%@ page import="org.icescrum.core.domain.Story" %>
<is:tableView>
  <is:table id="feature-table"
          editable="[controller:id,action:'update',params:[product:params.product],onExitCell:'submit']">

    <is:tableHeader class="table-cell-checkbox" name="" />
    <is:tableHeader name="" />
    <is:tableHeader name="${message(code:'is.feature.rank')}"/>
    <is:tableHeader name="${message(code:'is.feature.value')}"/>
    <is:tableHeader name="${message(code:'is.feature.type')}"/>
    <is:tableHeader name="${message(code:'is.feature')}"/>
    <is:tableHeader name="${message(code:'is.backlogelement.description')}"/>
    <is:tableHeader name="${message(code:'is.feature.effort')}"/>
    <is:tableHeader name="${message(code:'is.feature.stories')}"/>
    <is:tableHeader name="${message(code:'is.feature.stories.finish')}"/>

    <is:tableRows in="${features}" var="feature" elemID="id">
      <is:tableColumn class="table-cell-checkbox">
        <g:checkBox name="check-${feature.id}" />
      </is:tableColumn>
      <is:tableColumn class="table-cell-postit-icon">
        <is:postitIcon color="${feature.color}" />
      </is:tableColumn>
      <is:tableColumn editable="[type:'selectui',id:'rank',name:'rank',values:rankSelect,disabled:false]">${feature.rank}</is:tableColumn>
      <is:tableColumn editable="[type:'selectui',disabled:false,name:'value',values:suiteSelect]">${feature.value}</is:tableColumn>
      <is:tableColumn editable="[type:'selectui',id:'type',disabled:false,name:'type',values:typeSelect]"><is:bundleFromController bundle="typesBundle" value="${feature.type}"/></is:tableColumn>
      <is:tableColumn editable="[type:'text',disabled:false,name:'name']">${feature.name.encodeAsHTML()}</is:tableColumn>
      <is:tableColumn editable="[type:'textarea',disabled:false,name:'description']">${feature.description?.encodeAsHTML()}</is:tableColumn>
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