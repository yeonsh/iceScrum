<div class="box-blank clearfix">
  <p>${message(code:'is.ui.releasePlan.blankSprint.description')}</p>
  <table cellpadding="0" cellspacing="0" border="0" class="box-blank-button">
    <tr>
      <td class="empty">&nbsp;</td>
      <td>
          <is:button
            type="link"
            button="button-s button-s-light"
            history="false"
            remote="true"
            id="${release.id}"
            renderedOnAccess="productOwner() or scrumMaster()"
            controller="${id}"
            update="window-content-${id}"
            action="generateSprints"
            title="${message(code:'is.ui.releasePlan.blankSprint.generateSprints')}"
            alt="${message(code:'is.ui.releasePlan.blankSprint.generateSprints')}"
            icon="create" >
          <strong>${message(code:'is.ui.releasePlan.blankSprint.generateSprints')}</strong>
          </is:button>
      </td>
      <td class="empty">&nbsp;</td>      
      <td>
          <is:button
            type="link"
            button="button-s button-s-light"
            renderedOnAccess="productOwner() or scrumMaster()"
            href="#${id}/add/${release.id}"
            title="${message(code:'is.ui.releasePlan.blankSprint.new')}"
            alt="${message(code:'is.ui.releasePlan.blankSprint.new')}"
            icon="create" >
          <strong>${message(code:'is.ui.releasePlan.blankSprint.new')}</strong>
          </is:button>
      </td>
      <td class="empty">&nbsp;</td>
    </tr>
  </table>
</div>
<jq:jquery>
  jQuery("#window-content-${id}").removeClass('window-content-toolbar');
  jQuery("#window-id-${id}").focus();
  <is:renderNotice />
</jq:jquery>