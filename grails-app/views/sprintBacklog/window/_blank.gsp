<div class="box-blank clearfix">
  <p>${message(code:'is.ui.sprintBacklog.blank.description')}</p>
  <table cellpadding="0" cellspacing="0" border="0" class="box-blank-button">
    <tr>
      <td class="empty">&nbsp;</td>
      <td>
           <is:button
              type="link"
              button="button-s button-s-light"
              href="#releasePlan"
              renderedOnAccess="productOwner() or scrumMaster()"
              title="${message(code:'is.ui.sprintBacklog.blank.new')}"
              alt="${message(code:'is.ui.sprintBacklog.blank.sprint.new')}"
              icon="create" >
            <strong>${message(code:'is.ui.sprintBacklog.blank.sprint.new')}</strong>
          </is:button>
      </td>
      <td class="empty">&nbsp;</td>
      <td>
            <is:button
            type="link"
            button="button-s button-s-light"
            href="#timeline/add"
            renderedOnAccess="productOwner() or scrumMaster()"
            title="${message(code:'is.ui.sprintBacklog.blank.release.new')}"
            alt="${message(code:'is.ui.sprintBacklog.blank.release.new')}"
            icon="create" >
          <strong>${message(code:'is.ui.sprintBacklog.blank.release.new')}</strong>
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