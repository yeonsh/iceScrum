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
  <is:table id="story-table"
          editable="[controller:id,action:'update',params:[product:params.product],onExitCell:'submit']">

    <is:tableHeader class="table-cell-checkbox" name="" />
    <is:tableHeader name="" />
    <is:tableHeader name="${message(code:'is.story.rank')}"/>
    <is:tableHeader name="${message(code:'is.story.name')}"/>
    <is:tableHeader name="${message(code:'is.story.type')}"/>
    <is:tableHeader name="${message(code:'is.backlogelement.description')}"/>
    <is:tableHeader name="${message(code:'is.feature')}"/>
    <is:tableHeader name="${message(code:'is.story.effort')}"/>
    <is:tableHeader name="${message(code:'is.backlogelement.notes')}"/>
    <is:tableHeader name="${message(code:'is.story.date.accepted')}"/>
    <is:tableHeader name="${message(code:'is.story.date.estimated')}"/>

    <g:set var="productOwner" value="${sec.access([expression:'productOwner()'], {true})}"/>
    <g:set var="inProduct" value="${sec.access([expression:'inProduct()'], {true})}"/>

    <is:tableRows in="${stories}" var="story" elemID="id">
      <is:tableColumn class="table-cell-checkbox">
        <g:checkBox name="check-${story.id}" />
      </is:tableColumn>
      <is:tableColumn class="table-cell-postit-icon">
        <is:scrumLink id="${story.id}" controller="backlogElement"><is:postitIcon color="${story.feature?.color}"></is:postitIcon></is:scrumLink>
      </is:tableColumn>
      <is:tableColumn editable="[type:'selectui',id:'rank',disabled:!productOwner,name:'rank',values:rankSelect]">${story.rank}</is:tableColumn>
      <is:tableColumn editable="[type:'text',disabled:!productOwner,name:'name']">${story.name}</is:tableColumn>
      <is:tableColumn editable="[type:'selectui',id:'type',disabled:!productOwner,name:'type',values:typeSelect]"><is:bundleFromController bundle="typesBundle" value="${story.type}"/></is:tableColumn>
      <is:tableColumn editable="[type:'textarea',disabled:!productOwner,name:'description']">${story.description?.encodeAsHTML()}</is:tableColumn>
      <is:tableColumn editable="[type:'selectui',id:'feature',disabled:!productOwner,detach:true,name:'feature.id',values:featureSelect]"><g:message code="${story.feature?.name?:message(code:'is.ui.productBacklog.choose.feature')}"/></is:tableColumn>
      <is:tableColumn editable="[type:'selectui',id:'effort',disabled:!inProduct,name:'effort',values:suiteSelect]">${story.effort?:'?'}</is:tableColumn>
      <is:tableColumn editable="[type:'richarea',disabled:!productOwner,name:'notes']"><wikitext:renderHtml markup="Textile">${story.notes}</wikitext:renderHtml></is:tableColumn>
      <is:tableColumn><g:formatDate value="${story.acceptedDate}" formatName="is.date.format.short"/></is:tableColumn>
      <is:tableColumn><g:formatDate value="${story.estimatedDate}" formatName="is.date.format.short"/></is:tableColumn>
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