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

<%@ page import="org.icescrum.core.domain.Story;" %>
<div class="postit-details">
  <div class="colset-2 clearfix">
    <div class="col1 postit-details-information">
      <p>
        <strong><g:message code="is.backlogelement.id"/></strong> <is:scrumLink onclick="\$('#dialog').dialog('close');" controller="backlogElement" id="${story.id}">${story.id}</is:scrumLink>
      </p>
      <p>
        <strong><g:message code="is.story.name"/> :</strong> ${story.name}
      </p>
      <p>
        <strong><g:message code="is.story.type"/> :</strong> <g:message code="${typeCode}"/>
      </p>
      <g:if test="${story.state >= org.icescrum.core.domain.Story.STATE_ACCEPTED}">
        <p>
          <strong><g:message code="is.story.rank"/> :</strong> ${story.rank}
        </p>
      </g:if>
      <p>
        <strong><g:message code="is.backlogelement.description"/> :</strong> <is:storyTemplate story="${story}"/>
      </p>
      <div class="line">
        <strong><g:message code="is.backlogelement.notes"/> :</strong>
        <div class="content rich-content">
          <wikitext:renderHtml markup="Textile">${story.notes}</wikitext:renderHtml>
        </div>
      </div>
      <p>
        <strong><g:message code="is.story.date.suggested"/> :</strong>
        <g:formatDate date="${story.suggestedDate}" type="date" style="SHORT"/>
      </p>
      <g:if test="${story.state >= org.icescrum.core.domain.Story.STATE_ACCEPTED}">
        <p>
          <strong><g:message code="is.story.date.accepted"/> :</strong>
          <g:formatDate date="${story.acceptedDate}" type="date" style="SHORT"/>
        </p>
      </g:if>
      <g:if test="${story.state >= org.icescrum.core.domain.Story.STATE_ESTIMATED}">
        <p>
          <strong><g:message code="is.story.date.estimated"/> :</strong>
          <g:formatDate date="${story.estimatedDate}" type="date" style="SHORT"/>
        </p>
      </g:if>
      <g:if test="${story.state >= org.icescrum.core.domain.Story.STATE_PLANNED}">
        <p>
          <strong><g:message code="is.story.date.planned"/> :</strong>
          <g:formatDate date="${story.plannedDate}" type="date" style="SHORT"/>
        </p>
      </g:if>
      <g:if test="${story.state >= org.icescrum.core.domain.Story.STATE_INPROGRESS}">
      <p>
        <strong><g:message code="is.story.date.inprogress"/> :</strong>
        <g:formatDate date="${story.inProgressDate}" type="date" style="SHORT"/>
      </p>
      </g:if>
      <g:if test="${story.state == org.icescrum.core.domain.Story.STATE_DONE}">
        <p>
          <strong><g:message code="is.story.date.done"/> :</strong>
          <g:formatDate date="${story.doneDate}" type="date" style="SHORT"/>
        </p>
      </g:if>
      <p class="${story.feature?'':'last'}">
        <strong><g:message code="is.story.creator"/> :</strong> <is:scrumLink controller="user" action='profile' onclick="\$('#dialog').dialog('close');" id="${story.creator.username}">${story.creator.firstName.encodeAsHTML()} ${story.creator.lastName.encodeAsHTML()}</is:scrumLink>
      </p>
      <g:if test="${story.feature}">
      <p class="last">
        <strong><g:message code="is.feature"/> :</strong> ${story.feature.name.encodeAsHTML()}
      </p>
      </g:if>
    </div>
    <div class="col2">
        <is:postit title="${story.name.encodeAsHTML()}"
            id="${story.id}"
            miniId="${story.id}"
            rect="true"
            styleClass="story task${story.state == org.icescrum.core.domain.Story.STATE_DONE ? ' ui-selectable-disabled':''}"
            type="story"
            miniValue="${story.effort?:'?'}"
            color="${story.feature?.color ?: 'yellow'}"
            stateText="${is.bundleFromController(bundle:'StoryStateBundle',value:story.state)}">
      </is:postit>
      <g:if test="${story.comments?.size() >= 1}">
          <strong>
            <is:scrumLink
                    controller="backlogElement"
                    action="details"
                    id="${story.id}"
                    params="['comment':'true']"
                    onclick="\$('#dialog').dialog('close');">
              ${message(code:'is.postit.comment.count', args:[story.comments.size()])}
            </is:scrumLink>
          </strong>
      </g:if>
      <g:if test="${story.totalAttachments}">
        <div>
          <strong><g:message code="is.postit.attachment" args="[story.totalAttachments]"/> :</strong>
          <is:attachedFiles bean="${story}" width="120" deletable="${false}" params="[product:params.product]" action="download" controller="${(story.state > org.icescrum.core.domain.Story.STATE_SUGGESTED)?'productBacklog':'sandbox'}" size="20"/>
        </div>
      </g:if>
    </div>
  </div>
</div>