<form id="form-profile" method="post" class='box-form box-form-250 box-form-200-legend' onsubmit="jQuery('.ui-dialog-buttonpane button:eq(1)').click();return false;">
  <input type="hidden" id="user.id" name="user.id" value="${user.id}"/>
  <input type="hidden" id="product" name="product" value="${params.product}"/>
  <input type="hidden" id="user.version" name="user.version" value="${user.version}"/>
  <is:fieldset title="is.dialog.profile.general.title">
    <is:fieldInput for="userfirstName" label="is.user.firstname">
      <is:input id="userfirstName" name="user.firstName" value="${user.firstName}"/>
    </is:fieldInput>
    <is:fieldInput for="userlastName" label="is.user.lastname">
      <is:input id="userlastName" name="user.lastName" value="${user.lastName}"/>
    </is:fieldInput>
    <is:fieldInput for="userusername" label="is.user.username">
      <is:input id="userusername" name="user.username" value="${user.username}"/>
    </is:fieldInput>
    <is:fieldInput for="userpassword" label="is.user.password">
      <is:password id="userpassword" name="user.password"/>
    </is:fieldInput>
    <is:fieldInput for="confirmPassword" label="is.dialog.profile.confirmPassword">
      <is:password id="confirmPassword" name="confirmPassword"/>
    </is:fieldInput>
    <is:fieldInput for="useremail" label="is.user.email">
      <is:input id="useremail" name="user.email" value="${user.email}"/>
    </is:fieldInput>
    <is:fieldFile class="file-avatar" for="avatar" label="" noborder="true">
      <is:avatar elementId="preview-avatar" userid="${user.id}" nocache="true"/>
      <is:multiFilesUpload
        name="avatar"
        accept="['jpg','png','gif']"
        urlUpload="${createLink(action:'upload',controller:'scrumOS')}"
        multi="1"
        onUploadComplete="\$('#avatar-selected').val('');\$('#preview-avatar').attr('src','${createLink(action:'previewAvatar',controller:'user')}?fileID='+fileID);"
        progress="[
          url:createLink(action:'uploadStatus',controller:'scrumOS'),
          label:message(code:'is.upload.wait'),
        ]"/>
    </is:fieldFile>
    <is:fieldInput>
      <is:avatarSelector/>
    </is:fieldInput>
    <is:fieldInput for="activity" label="is.user.preferences.activity">
      <is:input name='user.preferences.activity' id='activity' value="${user.preferences.activity}"/>
    </is:fieldInput>
    <is:fieldSelect for="user.preferences.language" label="is.user.preferences.language" noborder="true">
      <is:localeSelecter width="170" styleSelect="dropdown" name="user.preferences.language" id="user.preferences.language" value="${user.preferences.language}"/>
    </is:fieldSelect>
  </is:fieldset>
</form>
<is:shortcut key="return" callback="jQuery('.ui-dialog-buttonpane button:eq(1)').click();" scope="form-profile" listenOn="'#form-profile input'"/>