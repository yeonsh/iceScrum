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

<%@ page import="grails.plugin.fluxiable.Activity" %>
<div class="dashboard">
  <div class="colset-2 clearfix">
    <div class="col1">

      <is:panel id="panel-description">
        <is:panelTitle><g:message code="is.ui.project.description.title"/></is:panelTitle>
          <div class="panel-box-content">
            <g:if test="${product.description}">
              <wikitext:renderHtml markup="Textile">${product.description}</wikitext:renderHtml>
            </g:if>
            <g:else>
              <g:message code="is.product.empty.description"/>
            </g:else>
          </div>
      </is:panel>
      <is:panel id="panel-vision">
        <is:panelTitle><g:message code="is.ui.project.vision.title"/></is:panelTitle>
        <div class="panel-box-content">
          <g:if test="${sprint?.parentRelease?.vision}">
            <wikitext:renderHtml markup="Textile">${is.truncated(value:sprint.parentRelease.vision,size:1000,encodeHTML:false)}</wikitext:renderHtml>
          </g:if>
          <g:else>
            <g:message code="is.release.empty.vision"/>
          </g:else>
        </div>
        <g:if test="${sprint?.parentRelease?.vision?.length() > 1000}">
            <div class="read-more">
             <is:scrumLink
                controller="releasePlan"
                action="vision"
                id="${sprint.parentRelease.id}">
                  <g:message code="is.ui.project.link.more"/>
                </is:scrumLink>
            </div>
        </g:if>
      </is:panel>
      <is:panel id="panel-doneDefinition">
        <is:panelTitle><g:message code="is.ui.project.doneDefinition.title"/></is:panelTitle>
        <div class="panel-box-content">
          <g:if test="${sprint?.doneDefinition}">
            <wikitext:renderHtml markup="Textile">${is.truncated(value:sprint.doneDefinition,size:1000,encodeHTML:false)}</wikitext:renderHtml>
          </g:if>
          <g:else>
            <g:message code="is.sprint.empty.doneDefinition"/>
          </g:else>
        </div>
        <g:if test="${sprint?.doneDefinition?.length() > 1000}">
            <div class="read-more">
              <is:scrumLink
                controller="sprintBacklog"
                action="doneDefinition"
                id="${sprint.id}">
                  <g:message code="is.ui.project.link.more"/>
                </is:scrumLink>
            </div>
        </g:if>
      </is:panel>
      <is:panel id="panel-retrospective">
        <is:panelTitle><g:message code="is.ui.project.retrospective.title"/></is:panelTitle>
        <div class="panel-box-content">
          <g:if test="${sprint?.retrospective}">
            <wikitext:renderHtml markup="Textile">${is.truncated(value:sprint.retrospective,size:1000,encodeHTML:false)}</wikitext:renderHtml>
          </g:if>
          <g:else>
            <g:message code="is.sprint.empty.retrospective"/>
          </g:else>
        </div>
        <g:if test="${sprint?.retrospective?.length() > 1000}">
            <div class="read-more">
              <is:scrumLink
                controller="sprintBacklog"
                action="retrospective"
                id="${sprint.id}">
                  <g:message code="is.ui.project.link.more"/>
                </is:scrumLink>
            </div>
        </g:if>
      </is:panel>

    </div>

    <div class="col2">

      <is:panel id="panel-activity">
        <is:panelTitle><g:link class="button-rss" action="feed" params="[product:product.pkey ]"><span class='ico'></span></g:link><g:message code="is.ui.project.activity.title"/></is:panelTitle>
        <g:if test="${activities.size() > 0}">
          <ul class="list-news">
            <g:each in="${activities}" var="a" status="i">
              <li ${(activities.size() == (i + 1)) ? 'class="last"' : ''}>
                <div class="news-item news-${a.code}">
                  <p>
                    <is:scrumLink controller="user" action='profile' id="${a.poster.username}">${a.poster.firstName} ${a.poster.lastName}</is:scrumLink>
                    <g:message code="is.fluxiable.${a.code}"/> <g:message code="is.story"/>
                    <g:if test="${a.code != Activity.CODE_DELETE}">
                      <is:scrumLink controller="backlogElement" id="${a.cachedId}" params="${a.code == 'comment' ? ['tab':'comments'] : []}">${a.cachedLabel.encodeAsHTML()}</is:scrumLink>
                    </g:if>
                    <g:else>
                      <strong>${a.cachedLabel.encodeAsHTML()}</strong>
                    </g:else>
                  </p>
                  <p><g:formatDate date="${a.dateCreated}"/></p>
                </div>
              </li>
            </g:each>
          </ul>
        </g:if>
        <g:else>
          <div class="panel-box-empty">
            <g:message code="is.fluxiable.no"/>
          </div>
        </g:else>
      </is:panel>
    </div>
  </div>
</div>

<jq:jquery>
  $('.list-news .news-item').hover(function(){
    $(this).addClass('news-item-hover');
  }, function(){
    $(this).removeClass('news-item-hover');
  });
  <icep:notifications
        name="${id}Dashboard"
        reload="[update:'#window-content-'+id,action:'dashboard',params:[product:params.product]]"
        group="${params.product}-product"
        listenOn="#window-content-${id}"/>
</jq:jquery>
