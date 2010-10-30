<ul>
  <li>${message(code: "is.product")}:
    <strong>${currentProduct.name}</strong>
    <sec:access expression='productOwner()'><is:remoteDialog
            action="openProperties"
            controller="project"
            params="[product:currentProduct.id]"
            valid="[action:'update',controller:'project',onSuccess:'\$(\'#project-details ul li:first strong\').text(data.name); \$.icescrum.renderNotice(data.notice);']"
            title="is.dialog.project.title"
            width="600"
            resizable="false"
            draggable="false">(<g:message code='default.button.edit.label'/>)</is:remoteDialog>
    </sec:access>
  </li>
  <li>${message(code:"is.role")}: <span class="roles"><is:scrumLink controller="members"><strong> <is:displayRole /> </strong></is:scrumLink></span><div class="clearfix"></div></li>
  <g:if test="${user}">
    <li><is:avatar userid="${user.id}"/></li>
  </g:if>
</ul>