<div class="box-blank clearfix">
  <p>${message(code:'is.ui.actor.blank.description')}</p>
  <table cellpadding="0" cellspacing="0" border="0" class="box-blank-button">
    <tr>
      <td class="empty">&nbsp;</td>
      <td>
          <is:button
            type="link"
            renderedOnAccess="productOwner()"
            button="button-s button-s-light"
            href="#${id}/add"
            title="${message(code:'is.ui.actor.blank.new')}"
            alt="${message(code:'is.ui.actor.blank.new')}"
            icon="create" >
          <strong>${message(code:'is.ui.actor.blank.new')}</strong>
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
  <icep:notifications
        name="${id}Window"
        reload="[update:'#window-content-'+id,action:'list',params:[product:params.product]]"
        disabled="!jQuery('#backlog-layout-window-${id}, .view-table').is(':hidden')"
        group="${params.product}-${id}"
        listenOn="#window-content-${id}"/>
</jq:jquery>