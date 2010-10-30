<div class="box-blank clearfix">
  <p>${message(code:'is.ui.sandbox.blank.description')}</p>
  <table cellpadding="0" cellspacing="0" border="0" class="box-blank-button">
    <tr>
      <td class="empty">&nbsp;</td>
      <td>
          <is:button
            type="link"
            button="button-s button-s-light"
            href="#${id}/add"
            title="${message(code:'is.ui.sandbox.blank.new')}"
            alt="${message(code:'is.ui.sandbox.blank.new')}"
            icon="create" >
          <strong>${message(code:'is.ui.sandbox.blank.new')}</strong>
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
<is:dropImport id="${id}" description="is.ui.sandbox.drop.import" action="dropImport"/>