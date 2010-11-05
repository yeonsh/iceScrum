<div class="postit-details">
  <div class="colset-2 clearfix">
    <div class="col1 postit-details-information">
      <p>
        <strong>%{--
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

<g:message code="is.backlogelement.id"/></strong> ${feature.id}
      </p>
      <p>
        <strong><g:message code="is.feature.name"/> :</strong> ${feature.name.encodeAsHTML()}
      </p>
       <p>
        <strong><g:message code="is.feature.type"/> :</strong> <g:message code="${type}" />
      </p>
      <p>
        <strong><g:message code="is.feature.rank"/> :</strong> ${feature.rank}
      </p>
      <p>
        <strong><g:message code="is.backlogelement.description"/> :</strong> ${feature.description?.encodeAsHTML()}
      </p>
      <div class="line">
        <strong><g:message code="is.backlogelement.notes"/> :</strong>
        <div class="content rich-content">
          <wikitext:renderHtml markup="Textile">${feature.notes}</wikitext:renderHtml>
        </div>
      </div>
      <p>
        <strong><g:message code="is.backlogelement.creationDate"/> :</strong>
        <g:formatDate date="${feature.creationDate}" formatName="is.date.format.short.time"/>
      </p>
     <g:if test="${feature.value}">
      <p>
        <strong><g:message code="is.feature.value"/> :</strong> ${feature.value}
      </p>
      </g:if>
      <p>
        <strong><g:message code="is.feature.effort"/> :</strong> ${effort}
      </p>
      <p>
        <strong><g:message code="is.feature.stories"/> :</strong> ${feature.stories?.size()}
      </p>
      <p class="last">
        <strong><g:message code="is.feature.stories.finish"/> :</strong> ${finishedStories}
      </p>
    </div>

    <div class="col2">
      <is:postit
        id="${feature.id}"
        miniId="${feature.id}"
        title="${feature.name.encodeAsHTML()}"
        color="${feature.color}"
        type="feature"
        rect="true"
        sortable='[restrictOnAccess:"productOwner()"]'
        typeName="${feature.type}">
      </is:postit>
      <g:if test="${feature.totalAttachments}">
        <div>
          <strong><g:message code="is.postit.attachment" args="[feature.totalAttachments]"/> :</strong>
          <is:attachedFiles bean="${feature}" width="120" deletable="${false}" action="download" controller="feature" params="[product:params.product]" size="20"/>
        </div>
      </g:if>
    </div>
  </div>
</div>