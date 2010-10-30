<ul>
  <li>${message(code:"is.team")}:
  <strong>${currentTeam.name}</strong>
    <sec:access expression='scrumMaster()'> <is:remoteDialog
            action="openProperties"
            controller="team"
            params="[team:currentTeam.id]"
            valid="[action:'update',controller:'team',onSuccess:'\$(\'#team-details ul li:first strong\').text(data.name); \$.icescrum.renderNotice(data.notice);']"
            title="is.dialog.team.title"
            width="600"
            resizable="false"
            draggable="false">(<g:message code='default.button.edit.label' />)</is:remoteDialog>
      </sec:access>
  </li>
  <li>${message(code:"is.role")}: <is:scrumLink controller="members"><strong> <is:displayRole /> </strong></is:scrumLink></li>
  <g:if test="${user}">
    <li><is:avatar userid="${user.id}"/></li>
  </g:if>
</ul>