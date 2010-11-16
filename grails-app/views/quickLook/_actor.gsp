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
<div class="postit-details">
  <div class="colset-2 clearfix">
    <div class="col1 postit-details-information">
      <p>
        <strong><g:message code="is.backlogelement.id"/> :</strong> ${actor.id}
      </p>
      <p>
        <strong><g:message code="is.actor.name"/> :</strong> ${actor.name.encodeAsHTML()}
      </p>
      <p>
        <strong><g:message code="is.backlogelement.description"/> :</strong> ${actor.description?.encodeAsHTML()}
      </p>
      <div class="line">
        <strong><g:message code="is.backlogelement.notes"/> :</strong>
        <div class="content rich-content">
          <wikitext:renderHtml markup="Textile">${actor.notes}</wikitext:renderHtml>
        </div>
      </div>
      <p>
        <strong><g:message code="is.backlogelement.creationDate"/> :</strong>
        <g:formatDate date="${actor.creationDate}" formatName="is.date.format.short.time"/>
      </p>
      <p>
        <strong><g:message code="is.actor.satisfaction.criteria"/> :</strong> ${actor.satisfactionCriteria?.encodeAsHTML()}
      </p>
      <p>
        <strong><g:message code="is.actor.it.level"/> :</strong> <g:message code="${expertnessLevelCode}" />
      </p>
      <p>
        <strong><g:message code="is.actor.use.frequency"/> :</strong> <g:message code="${useFrequencyCode}"/>
      </p>
      <p>
        <strong><g:message code="is.actor.instances"/> :</strong> <g:message code="${instancesCode}"/>
      </p>
      <p class="last">
        <strong><g:message code="is.actor.nb.stories"/> :</strong> ${stories}
      </p>
    </div>
    <div class="col2">
      <is:postit id="${actor.id}"
            miniId="${actor.id}"
            title="${actor.name.encodeAsHTML()}"
            type="actor"
            rect="true"
            controller="actor">
      </is:postit>
      <g:if test="${actor.totalAttachments}">
        <div>
          <strong>${message(code:'is.postit.attachment', args:[actor.totalAttachments, actor.totalAttachments > 1 ? 's' : '' ])} :</strong>
          <is:attachedFiles bean="${actor}" width="120" deletable="${false}" action="download" controller="actor" params="[product:params.product]" size="20"/>
        </div>
      </g:if>
    </div>
  </div>
</div>
