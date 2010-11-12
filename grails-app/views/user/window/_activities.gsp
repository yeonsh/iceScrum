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
- Manuarii Stein (manuarii.stein@icescrum.com)
--}%
<%@ page import="org.icescrum.web.presentation.app.project.ProductBacklogController; grails.plugin.fluxiable.Activity; grails.plugin.fluxiable.ActivityLink; org.grails.comments.Comment" %>
<is:panel id="panel-activity">
  <is:panelTitle>${message(code: 'is.ui.backlogelement.activity')}</is:panelTitle>
  <is:panelTabButton id="panel-box-1">
    <a rel="#history" href="../" class="${!params.tab || 'history' in params.tab ? 'selected' : ''}">${message(code: 'is.ui.backlogelement.activity.history')}</a>
    <a rel="#stories" href="../" class="${params.tab && 'stories' in params.tab ? 'selected' : ''}">${message(code: 'is.ui.backlogelement.activity.stories')}</a>
    <a rel="#tasks" href="../" class="${params.tab && 'tasks' in params.tab ? 'selected' : ''}">${message(code: 'is.ui.backlogelement.activity.task')}</a>
    <a rel="#teams" href="../" class="${params.tab && 'teams' in params.tab ? 'selected' : ''}">${message(code: 'is.user.teams')}</a>
  </is:panelTabButton>
  <div id="panel-tab-contents-1" class="panel-tab-contents">

  %{--History panel--}%
    <is:panelTab id="history" selected="${!params.tab || 'summary' in params.tab ? 'true' : ''}">
      <g:if test="${activities?.size() > 0}">
        <ul class="list-news">
          <g:each in="${activities}" var="a" status="i">
            <li ${(activities?.size() == (i + 1)) ? 'class="last"' : ''}>
              <div class="news-item news-${a.code}">
                <p>${a.poster.firstName} ${a.poster.lastName}
                  <g:message code="is.fluxiable.${a.code}"/>
                  <g:message code="is.${a.code.startsWith('task') ? 'task' : 'story'}"/>
                  <g:if test="${!a.code.startsWith('task') && a.code != Activity.CODE_DELETE}">
                    <g:link class="scrum-link" action="idURL"  controller="backlogElement" id="${a.cachedId}">${a.cachedLabel.encodeAsHTML()}</g:link></p>
                  </g:if>
                  <g:else>
                    <strong>${a.cachedLabel.encodeAsHTML()}</strong>
                  </g:else>
                <p><g:formatDate date="${a.dateCreated}" formatName="is.date.format.short.time"/></p>
              </div>
            </li>
          </g:each>
        </ul>
      </g:if>
      <g:else>
        <div class="panel-box-empty">
          ${message(code: 'is.ui.backlogelement.activity.history.no')}
        </div>
      </g:else>
    </is:panelTab>

 %{--Stories panel--}%
    <is:panelTab id="stories" selected="${params.tab && 'stories' in params.tab ? 'true' : ''}">
      <g:if test="${stories}">
        <is:tableView>
          <is:table id="stories-table">
            <is:tableHeader name=""/>
            <is:tableHeader name="${message(code:'is.story.name')}"/>
            <is:tableHeader name="${message(code:'is.story.state')}"/>
            <is:tableHeader name="${message(code:'is.story.lastUpdated')}"/>

            <is:tableRows in="${stories}" var="story">
              <is:tableColumn><is:scrumLink product="${story.backlog.pkey}" controller="backlogElement" id="${story.id}">${story.backlog.pkey}-${story.id}</is:scrumLink></is:tableColumn>
              <is:tableColumn>${story.name.encodeAsHTML()}</is:tableColumn>
              <is:tableColumn>${message(code:ProductBacklogController.stateBundle[story.state])}</is:tableColumn>
              <is:tableColumn><g:formatDate date="${story.lastUpdated}" formatName="is.date.format.short.time"/></is:tableColumn>
            </is:tableRows>
          </is:table>
        </is:tableView>
      </g:if>
      <g:else><div class="panel-box-empty">${message(code: 'is.ui.backlogelement.activity.task.no')}</div></g:else>
    </is:panelTab>


  %{--Tasks panel--}%
    <is:panelTab id="tasks" selected="${params.tab && 'tasks' in params.tab ? 'true' : ''}">
      <g:if test="${tasks}">
        <is:tableView>
          <is:table id="task-table">
            <is:tableHeader name="${message(code:'is.sprint')}"/>
            <is:tableHeader name="${message(code:'is.story')}"/>
            <is:tableHeader name="${message(code:'is.task.name')}"/>
            <is:tableHeader name="${message(code:'is.task.estimation')}"/>
            <is:tableHeader name="${message(code:'is.task.creator')}"/>

            <is:tableRows in="${tasks}" var="task">
              <is:tableColumn><is:scrumLink product="${task.backlog.parentRelease.parentProduct.pkey}" controller="sprintBacklog" id="${task.backlog.id}">${task.backlog.parentRelease.parentProduct.name.encodeAsHTML()} - ${task.backlog.orderNumber}</is:scrumLink></is:tableColumn>
              <is:tableColumn><g:if test="${task.parentStory}"><is:scrumLink product="${task.parentStory.backlog.pkey}" controller="backlogElement" id="${task.parentStory.id}">${task.parentStory.name.encodeAsHTML()}</is:scrumLink></g:if></is:tableColumn>
              <is:tableColumn>${task.name.encodeAsHTML()}</is:tableColumn>
              <is:tableColumn>${task.estimation >= 0 ? task.estimation : '?'}</is:tableColumn>
              <is:tableColumn>${task.creator.firstName.encodeAsHTML()} ${task.creator.lastName.encodeAsHTML()}</is:tableColumn>
            </is:tableRows>
          </is:table>
        </is:tableView>
      </g:if>
      <g:else><div class="panel-box-empty">${message(code: 'is.ui.backlogelement.activity.task.no')}</div></g:else>
    </is:panelTab>


    <is:panelTab id="teams" selected="${params.tab && 'teams' in params.tab ? 'true' : ''}">
      <g:if test="${user.teams}">
        <is:tableView>
          <is:table id="task-table">
            <is:tableHeader name="${message(code:'is.team.name')}"/>

            <is:tableRows in="${user.teams}" var="team">
              <is:tableColumn>${team.name.encodeAsHTML()}</is:tableColumn>
            </is:tableRows>
          </is:table>
        </is:tableView>
      </g:if>
      <g:else><div class="panel-box-empty">${message(code: 'is.ui.backlogelement.activity.task.no')}</div></g:else>
    </is:panelTab>
  </div>

  <jq:jquery>
    $("#panel-box-1 a").each(function() {
      var item = $(this);
      var rel = $(item.attr('rel'));
      item.click(function(){
        $("#panel-tab-contents-1 .tab-selected").hide();
        $("#panel-tab-contents-1 .tab-selected").removeClass("tab-selected");
        $("#panel-box-1 .selected").removeClass("selected");
        item.addClass("selected");
        rel.addClass("tab-selected");
        rel.show();
        return false;
      });
    });
  </jq:jquery>

</is:panel>