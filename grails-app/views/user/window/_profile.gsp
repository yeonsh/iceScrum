<%@ page import="grails.plugin.fluxiable.ActivityLink; grails.plugin.fluxiable.Activity; org.grails.comments.Comment; org.icescrum.core.domain.Story" %>
<div class="dashboard">
  <div class="colset-2-80 clearfix">
    <div class="col1">

      <is:panel id="panel-infos">
        <is:panelTitle>${message(code:'is.ui.backlogelement.information')}</is:panelTitle>
        <is:panelContext>
          <is:panelLine legend="${message(code:'is.user.firstname')}">${user.firstName?.encodeAsHTML()}</is:panelLine>
          <is:panelLine legend="${message(code:'is.user.lastname')}">${user.lastName?.encodeAsHTML()}</is:panelLine>
          <is:panelLine legend="${message(code:'is.user.username')}">${user.username.encodeAsHTML()}</is:panelLine>
          <is:panelLine legend="${message(code:'is.user.preferences.activity')}">${user.preferences.activity?.encodeAsHTML()}</is:panelLine>
          <is:panelLine legend="${message(code:'is.user.email')}"><a href="mailto:${user.email}">${user.email.encodeAsHTML()}</a></is:panelLine>
          <is:panelLine legend="${message(code:'is.permalink')}"><a href="${permalink}">${permalink}</a></is:panelLine>
        </is:panelContext>
      </is:panel>
      <div id="activities-wrapper">
        <g:render template="window/activities" model="[activities:activities, user:user, tasks:tasks, stories:stories]"/>
      </div>

    </div>

    <div class="col2">

      <is:panel id="panel-progress">
        <is:panelContext>
          <is:panelLine legend="">
           <is:avatar userid="${user.id}"/>
          </is:panelLine>
        </is:panelContext>
      </is:panel>

      <is:panel id="panel-dates">
        <is:panelTitle>${message(code:'is.ui.backlogelement.dates')}</is:panelTitle>
        <is:panelContext>
          <is:panelLine legend="${message(code:'is.user.dateCreated')}"><g:formatDate date="${user.dateCreated}" formatName="is.date.format.short"/></is:panelLine>
          <is:panelLine legend="${message(code:'is.user.lastUpdated')}"><g:formatDate date="${user.lastUpdated}" formatName="is.date.format.short"/></is:panelLine>
        </is:panelContext>
      </is:panel>

      <is:panel id="panel-progress">
        <is:panelTitle>${message(code:'is.ui.backlogelement.progress')}</is:panelTitle>
        <is:panelContext>
          <is:panelLine legend="${message(code:'is.ui.backlogelement.progress.tasks')}">
           ${inProgressTasks}
          </is:panelLine>
        </is:panelContext>
      </is:panel>

    </div>
  </div>
</div>
<jq:jquery>
  <is:renderJavascript/>
</jq:jquery>