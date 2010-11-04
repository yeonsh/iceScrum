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

<%@ page import="org.icescrum.core.domain.Task;org.icescrum.core.domain.Sprint;org.icescrum.core.domain.Story;" %>
<is:tableView>
<is:kanban selectable="[filter:'.postit-rect',
                        cancel:'.postit-label, .postit-story, a, .mini-value, select, input',
                        selected:'\$.icescrum.dblclickSelectable(ui,300,function(obj){'+is.quickLook(params:'\'task.id=\'+\$(obj.selected).icescrum(\'postit\').id()')+';})',
                        onload:'\$(\'.window-toolbar\').icescrum(\'toolbar\', \'buttons\', 0).toggleEnabled(\'.backlog\');']">
%{-- Columns' headers --}%
  <is:kanbanHeader name="Story" key="story"/>
  <g:each in="${columns}" var="column">
    <is:kanbanHeader name="${message(code:column.name)}" key="${column.key}"/>
  </g:each>

%{-- Recurrent Tasks --}%
  <is:kanbanRow rendered="${displayRecurrentTasks}">
    <is:kanbanColumn key="story">
      <g:message code="is.ui.sprintBacklog.kanban.recurrentTasks"/>
      <br/>
        <is:link
            action="add"
            rendered="${sprint.state != org.icescrum.core.domain.Sprint.STATE_DONE}"
            id="${sprint.id}"
            controller="${id}"
            params="['story.id':'recurrent']"
            remote="true"
            alt="${message(code:'is.ui.sprintBacklog.kanban.recurrentTasks.add')}"
            update="window-content-${id}">
          ${message(code: 'is.ui.sprintBacklog.kanban.recurrentTasks.add')}
        </is:link>
        <br/>
        <is:link
            action="copyRecurrentTasksFromPreviousSprint"
            rendered="${sprint.state != org.icescrum.core.domain.Sprint.STATE_DONE && previousSprintExist}"
            id="${sprint.id}"
            controller="${id}"
            remote="true"
            history="false"
            alt="${message(code:'is.ui.sprintBacklog.kanban.copyRecurrentTasks')}"
            update="window-content-${id}">
          ${message(code: 'is.ui.sprintBacklog.kanban.copyRecurrentTasks')}
        </is:link>
    </is:kanbanColumn>
    <g:each in="${columns}" var="column" status="i">
      <is:kanbanColumn
              elementId="column-recurrent-${column.key}"
              key="${column.key}"
              class="${(column.key != Task.STATE_WAIT && sprint.state != org.icescrum.core.domain.Sprint.STATE_INPROGRESS)?'no-drop':''}"
              sortable='[handle:".postit-label",
                      cancel: ".ui-selectable-disabled",
                      connectWith:".kanban-cell",
                      update:"if(\$(\"#column-recurrent-${column.key} .postit-rect\").index(ui.item) == -1 || ui.sender != undefined){return}else{${is.changeRank(selector:"#column-recurrent-${column.key} .postit-rect",controller:id,action:"changeRank",params:"&product=${params.product}")}}",
                      placeholder:"postit-placeholder ui-corner-all",
                      receive:remoteFunction(
                                      before:"if(\$(this).hasClass(\"no-drop\")){\$(ui.sender).sortable(\"cancel\"); return;}",
                                      controller:id,
                                      action:"changeState",
                                      id:column.key,
                                      update:"window-content-${id}",
                                      onFailure: "\$(ui.sender).sortable(\"cancel\");",
                                      params: "\"product=${params.product}&task.id=\"+ui.item.find(\".postit-id\").text()+\"&task.type=${Task.TYPE_RECURRENT}&position=\"+(\$(this).find(\".postit-rect\").index(ui.item)+1)")]'>
        <g:each in="${recurrentTasks?.sort{it.rank}?.findAll{ it.state == column.key} }" var="task">

        %{-- Task postit --}%
          <is:postit title="${task.name}"
                  id="${task.id}"
                  miniId="${task.id}"
                  styleClass="story task${((task.state == Task.STATE_DONE) || (task.responsible && task.responsible.id != user.id))?' ui-selectable-disabled':''}"
                  type="task"
                  attachment="${task.totalAttachments}"
                  stateText="${task.responsible?.firstName?.encodeAsHTML() ?: ''} ${task.responsible?.lastName?.encodeAsHTML() ?: ''}"
                  miniValue="${task.estimation ?: task.estimation == 0?'0':'?'}"
                  editableEstimation="${(task.responsible && task.responsible.id == user.id  && task.state != org.icescrum.core.domain.Task.STATE_DONE) || (!task.responsible && task.creator.id == user.id && task.state != Task.STATE_DONE)}"
                  color="yellow"
                  rect="true">
            <sec:access expression="inProduct()">
                <is:postitMenu id="recurrent-task-${task.id}" contentView="window/taskMenu" params="[id:id, task:task, story:story, user:user]" rendered="${sprint.state != org.icescrum.core.domain.Sprint.STATE_DONE}"/>
            </sec:access>
          </is:postit>
          <g:if test="${task.name?.length() > 17 || task.description?.length() > 0}">
              <is:tooltipPostit
                      type="task"
                      id="${task.id}"
                      title="${task.name?.encodeAsHTML()}"
                      text="${task.description?.encodeAsHTML()}"
                      apiBeforeShow="if(\$('#dropmenu').is(':visible')){return false;}"
                      container="\$('#window-content-${id} .view-table')"/>
          </g:if>
        </g:each>
 
      </is:kanbanColumn>
    </g:each>
  </is:kanbanRow>

%{-- Urgent Tasks --}%
  <is:kanbanRow rendered="${displayUrgentTasks}">
    <is:kanbanColumn key="story">
      <g:message code="is.ui.sprintBacklog.kanban.urgentTasks"/>
      <br/>
      <is:link
            action="add"
            rendered="${sprint.state != org.icescrum.core.domain.Sprint.STATE_DONE}"
            id="${sprint.id}"
            params="['story.id':'urgent']"
            controller="${id}"
            remote="true"
            alt="${message(code:'is.ui.sprintBacklog.kanban.urgentTasks.add')}"
            update="window-content-${id}">
            ${message(code: 'is.ui.sprintBacklog.kanban.urgentTasks.add')}
        </is:link>
      <br/>
      <span>${(limitValueUrgentTasks)?message(code: 'is.ui.sprintBacklog.kanban.urgentTasks.limit', args:[limitValueUrgentTasks]):''}</span>
    </is:kanbanColumn>
    <g:each in="${columns}" var="column">
      <is:kanbanColumn
                      elementId="column-urgent-${column.key}"
                      key="${column.key}"
                      class="${((sprint.state != org.icescrum.core.domain.Sprint.STATE_INPROGRESS && column.key != Task.STATE_WAIT) || (urgentTasksLimited && limitValueUrgentTasks && column.key == org.icescrum.core.domain.Task.STATE_BUSY))?'no-drop':''}"
                      sortable='[handle:".postit-label",
                                update:"if(\$(\"#column-urgent-${column.key} .postit-rect\").index(ui.item) == -1 || ui.sender != undefined){return}else{${is.changeRank(selector:"#column-urgent-${column.key} .postit-rect",controller:id,action:"changeRank",params:"&product=${params.product}")}}",                                                      
                                cancel: ".ui-selectable-disabled",
                                connectWith:".kanban-cell",
                                placeholder:"postit-placeholder ui-corner-all",
                                receive:remoteFunction(
                                                controller:id,
                                                before:"if(\$(this).hasClass(\"no-drop\")){\$(ui.sender).sortable(\"cancel\"); return;}",
                                                action:"changeState",
                                                id:column.key,
                                                update:"window-content-${id}",
                                                onFailure: "\$(ui.sender).sortable(\"cancel\");",
                                                params: "\"product=${params.product}&task.id=\"+ui.item.find(\".postit-id\").text()+\"&task.type=${org.icescrum.core.domain.Task.TYPE_URGENT}&position=\"+(\$(this).find(\".postit-rect\").index(ui.item)+1)")
                                ]'>
        <g:each in="${urgentTasks?.sort{it.rank}?.findAll{it.state == column.key}}"
                var="task">

        %{-- Task postit --}%
          <is:postit title="${task.name}"
                  id="${task.id}" miniId="${task.id}"
                  styleClass="story task${((task.state == Task.STATE_DONE) || (task.responsible && task.responsible.id != user.id))? ' ui-selectable-disabled':''}"
                  type="task"
                  attachment="${task.totalAttachments}"
                  stateText="${task.responsible?.firstName?.encodeAsHTML() ?: ''} ${task.responsible?.lastName?.encodeAsHTML() ?: ''}"
                  miniValue="${task.estimation ?: task.estimation == 0?'0':'?'}"
                  editableEstimation="${(task?.responsible && task?.responsible?.id == user.id  && task?.state != org.icescrum.core.domain.Task.STATE_DONE) || (!task?.responsible && task?.creator?.id == user.id && task?.state != org.icescrum.core.domain.Task.STATE_DONE)}"
                  color="yellow"
                  rect="true">
            <sec:access expression="inProduct()">
              <is:postitMenu id="urgent-task-${task.id}" contentView="window/taskMenu" params="[id:id, task:task, story:story, user:user]" rendered="${sprint.state != org.icescrum.core.domain.Sprint.STATE_DONE}"/>
            </sec:access>
          </is:postit>
          <g:if test="${task.name?.length() > 17 || task.description?.length() > 0}">
            <is:tooltipPostit
                    type="task"
                    id="${task.id}"
                    title="${task.name?.encodeAsHTML()}"
                    text="${task.description?.encodeAsHTML()}"
                    apiBeforeShow="if(\$('#dropmenu').is(':visible')){return false;}"
                    container="\$('#window-content-${id} .view-table')"/>
          </g:if>
        </g:each>
      </is:kanbanColumn>
    </g:each>
  </is:kanbanRow>

%{-- Stories Rows --}%
  <is:kanbanRows in="${stories.sort{it.rank}}" var="story">
    <is:kanbanColumn
            elementId="column-story-${story.id}"
            key="story">
      <g:if test="${story}">
        <is:postit id="${story.id}"
                miniId="${story.id}"
                title="${story.name}"
                styleClass="story type-story-${story.type}"
                type="story"
                attachment="${story.totalAttachments}"
                typeName="${story.type}"
                miniValue="${story.effort >= 0 ? story.effort :'?'}"
                color="${story.feature?.color}"
                stateText="${is.bundleFromController(bundle:'stateBundle',value:story.state)}"
                editableEstimation="${(task?.responsible && task?.responsible?.id == user.id  && task?.state != org.icescrum.core.domain.Task.STATE_DONE) || (!task?.responsible && task?.creator?.id == user.id && task?.state != Task.STATE_DONE)}"
                controller="${id}"
                comment="${story.totalComments >= 0 ? story.totalComments : ''}">
          <is:truncated size="60"><is:storyTemplate story="${story}"/></is:truncated>

          %{--Embedded menu--}%
          <is:postitMenu id="${story.id}" contentView="window/postitMenu" params="[id:id,story:story,nextSprintExist:nextSprintExist]"/>
            
          <g:if test="${story.name?.length() > 17 || is.storyTemplate(story:story)?.length() > 65}">
            <is:tooltipPostit
                    type="story"
                    id="${story.id}"
                    title="${story.name.encodeAsHTML()}"
                    text="${is.storyTemplate(story:story)}"
                    apiBeforeShow="if(\$('#dropmenu').is(':visible')){return false;}"
                    container="\$('#window-content-${id} .view-table')"/>
          </g:if>
        </is:postit>
      </g:if>
    </is:kanbanColumn>

  %{-- Workflow Columns --}%
    <g:each in="${columns}" var="column">
      <is:kanbanColumn
                elementId="column-story-${story.id}-${column.key}"
                key="${column.key}"
                class="${(column.key != Task.STATE_WAIT && sprint.state != org.icescrum.core.domain.Sprint.STATE_INPROGRESS)?'no-drop':''}"
                sortable='[handle:".postit-label",
                      cancel: ".ui-selectable-disabled",
                      connectWith:".kanban-cell",
                      update:"if(\$(\"#column-story-${story.id}-${column.key} .postit-rect\").index(ui.item) == -1 || ui.sender != undefined){return}else{${is.changeRank(selector:"#column-story-${story.id}-${column.key} .postit-rect",controller:id,action:"changeRank",params:"&product=${params.product}")}}",
                      placeholder:"postit-placeholder ui-corner-all",
                      receive:remoteFunction(
                                      before:"if(\$(this).hasClass(\"no-drop\")){\$(ui.sender).sortable(\"cancel\"); return;}",
                                      controller:id,
                                      action:"changeState",
                                      id:column.key,
                                      update:"window-content-${id}",
                                      onFailure: "\$(ui.sender).sortable(\"cancel\");",
                                      params: "\"product=${params.product}&task.id=\"+ui.item.find(\".postit-id\").text()+\"&story.id=${story.id}&position=\"+(\$(this).find(\".postit-rect\").index(ui.item)+1)")]'>
        <g:each in="${story.tasks?.sort{it.rank}?.findAll{ it.state == column.key}}" var="task">

        %{-- Task postit --}%
          <is:postit title="${task.name}"
                  id="${task.id}"
                  miniId="${task.id}"
                  styleClass="story task${((task.state == org.icescrum.core.domain.Task.STATE_DONE) || (task.responsible && task.responsible.id != user.id))? ' ui-selectable-disabled':''}"
                  type="task"
                  attachment="${task.totalAttachments}"
                  rect="true"
                  miniValue="${task.estimation ?: task.estimation == 0?'0':'?'}"
                  stateText="${task.responsible?.firstName ?: ''} ${task.responsible?.lastName ?: ''}"
                  editableEstimation="${(task?.responsible && task?.responsible?.id == user.id  && task?.state != Task.STATE_DONE) || (!task?.responsible && task?.creator?.id == user.id && task?.state != Task.STATE_DONE)}"
                  color="yellow">
            <sec:access expression="inProduct()">
              <is:postitMenu id="story-task-${task.id}" contentView="window/taskMenu" params="[id:id, task:task, story:story, user:user]" rendered="${sprint.state != org.icescrum.core.domain.Sprint.STATE_DONE}"/>
            </sec:access>
          </is:postit>
          <g:if test="${task.name?.length() > 17 || task.description?.length() > 0}">
           <is:tooltipPostit
                    type="task"
                    id="${task.id}"
                    title="${task.name?.encodeAsHTML()}"
                    text="${task.description?.encodeAsHTML()}"
                    apiBeforeShow="if(\$('#dropmenu').is(':visible')){return false;}"
                    container="\$('#window-content-${id} .view-table')"/>
            </g:if>
        </g:each>
      </is:kanbanColumn>
    </g:each>
  </is:kanbanRows>

</is:kanban>
</is:tableView>
<jq:jquery>
  jQuery('.postit-story').dblclick(function(e){ var obj = jQuery(e.currentTarget);${is.quickLook(params:'\'story.id=\'+obj.attr(\"elemId\")')}});
  jQuery("#window-content-${id}").removeClass('window-content-toolbar');
  if(!jQuery("#dropmenu").is(':visible')){
    jQuery("#window-id-${id}").focus();
  }
  $('#selectOnSprintBacklog').changeSelectValue(${sprint.id});
  jQuery('#window-title-bar-${id} .content').html('${message(code:"is.ui."+id)} - ${message(code:"is.sprint")} ${sprint.orderNumber}  - ${is.bundleFromController(bundle:'SprintStateBundle',value:sprint.state)}');
  <is:renderJavascript />
  <is:renderNotice />
  <icep:notifications
        name="${id}Window"
        disabled="!jQuery('.view-table').is(':hidden')"
        reload="[update:'#window-content-'+id,action:'index',id:sprint.id,params:[product:params.product]]"
        group="${params.product}-${id}-${sprint.id}"
        listenOn="#window-content-${id}"/>
</jq:jquery>
<is:editable
        on=".mini-value.editable"
        typed="[type:'numeric',allow:'?']"
        wrap="true"
        onExit="submit"
        action="estimateTask"
        controller="${id}"
        before="\$(this).next().hide();"
        cancel="\$(original).next().show();"
        callback="\$(this).next().show();"
        params="[product:params.product]"
        findId="\$(this).parent().parent().parent().attr(\'elemID\')"/>
<is:shortcut key="space" callback="if(\$('#dialog').dialog('isOpen') == true){\$('#dialog').dialog('close'); return false;}\$.icescrum.dblclickSelectable(null,null,function(obj){${is.quickLook(params:'\'task.id=\'+jQuery(obj.selected).icescrum(\'postit\').id()')}},true);" scope="${id}"/>
<is:shortcut key="ctrl+a" callback="\$('#window-content-${id} .ui-selectee').addClass('ui-selected');"/>