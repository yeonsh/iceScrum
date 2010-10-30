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

<g:setProvider library="jquery"/>

<g:form action="save" method="post" name="${id}-form" class="box-form box-form-250 box-form-200-legend" tabindex="1">
  <g:if test="${referrer != null}">
    <g:hiddenField name="referrer.controller" value="${referrer?.controller}"/>
    <g:hiddenField name="referrer.action" value="${referrer?.action}"/>
    <g:hiddenField name="referrer.id" value="${referrer?.id}"/>
  </g:if>

  <is:fieldset title="is.ui.productBacklog.story.properties.title">
    <is:fieldInput for="storyname" label="is.story.name">
        <is:input id="storyname" name="story.name" value="${story.name}"/>
    </is:fieldInput>

    <is:fieldSelect label="is.story.type" for="story.type">
      <is:select container="#window-content-${referrer?.controller ?: id}" width="195" maxHeight="100" styleSelect="dropdown" from="${typesLabels}" keys="${typesKeys}" name="story.type" value="${story.type}"/>
    </is:fieldSelect>

    <is:fieldSelect label="is.feature" for="story.feature">
      <is:select container="#window-content-${referrer?.controller ?: id}" width="195" maxHeight="100" styleSelect="dropdown" name="feature.id" noSelection="['':message(code:'is.ui.productBacklog.choose.feature')]" optionValue="name" optionKey="id" from="${featureSelect}" value="${story.feature?.id}"/>
    </is:fieldSelect>
    <g:if test="${referrer == null}">
      <is:fieldSelect label="is.story.rank" for="story.rank">
        <is:select container="#window-content-${id}" width="100" maxHeight="100" styleSelect="dropdown" from="${rankList}" name="story.rank" value="${story.rank}"/>
      </is:fieldSelect>
    </g:if>
    <is:fieldArea for="storydescription" label="${message(code:'is.backlogelement.description')}" noborder="true">
          <is:area id="storydescription" large="true" name="story.description" value="${story?.description}" rows="7"/>
      </is:fieldArea>
  </is:fieldset>

  <is:textTemplate
          title="is.story.template"
          id="story-template"
          label="is.ui.productBacklog.story.template"
          checked="${isUsedTemplate}">

      <is:textTemplateRow title="${message(code:'is.story.template.as')}" for="story-textAs">
        <is:autoCompleteSkin
                controller="actor"
                action="search"
                id="story-textAs"
                name="story.textAs"
                minLength="1"
                value="${story?.actor?.name ?: story?.textAs ?: ''}"/>
      </is:textTemplateRow>

      <is:textTemplateRow title="${message(code:'is.story.template.ican')}">
        <is:area id="storytextICan" name="story.textICan" value="${story?.textICan}"/>
      </is:textTemplateRow>

      <is:textTemplateRow title="${message(code:'is.story.template.to')}">
        <is:area id="storytextTo"
                name="story.textTo"
                value="${story?.textTo}"/>
      </is:textTemplateRow>
  </is:textTemplate>

  <is:fieldset title="is.ui.productBacklog.story.attachment.title">
    <is:fieldFile for='story.attachments' label="is.backlogelement.attachment" noborder="true">
        <is:multiFilesUpload elementId="storyattachments"
                      name="attachments"
                      bean="${story}"
                      urlUpload="${createLink(action:'upload',controller:'scrumOS')}"
                      params="[product:params.product]"
                      progress="[
                        url:createLink(action:'uploadStatus',controller:'scrumOS'),
                        label:message(code:'is.upload.wait')
                      ]"/>
    </is:fieldFile>
  </is:fieldset>

  <is:fieldset title="is.ui.productBacklog.story.notes.title">
   <is:fieldArea for="storynotes" label="is.backlogelement.notes" noborder="true">
      <is:area rich="[preview:true,fillWidth:true,margin:250,height:250]"
              id="storynotes"
              name="story.notes"
              value="${story?.notes}"/>
   </is:fieldArea>
  </is:fieldset>

  <g:if test="${currentPanel == 'edit'}">
    <g:hiddenField name="story.version" value="${story.version}"/>
    <g:hiddenField name="story.id" value="${story.id}"/>
  </g:if>

  <is:buttonBar>
    <g:if test="${referrer == null && nextStoryId}">
      <is:button
              targetLocation="${controllerName+'/'+actionName+'/'+nextStoryId}"
              id="submitAndContinueForm"
              type="submitToRemote"
              url="[controller:'productBacklog', action:'update', params:[continue:true,product:params.product]]"
              update="window-content-${id}"
              before='if (\$.icescrum.uploading()) {${is.notice(text:message(code:"is.upload.inprogress.wait"))} return false; }'
              value="${message(code:'is.button.update')} ${message(code:'is.button.andContinue')}"/>
    </g:if>
    <is:button
            targetLocation="${referrer?.controller ?: 'productBacklog' + referrer?.action ?'/'+referrer?.action:''+ referrer?.id ?'/'+referrer?.id:''}"
            id="submitForm" type="submitToRemote"
            url="[controller:'productBacklog', action:'update', params:[product:params.product]]"
            update="window-content-${referrer?.controller ?: id}"
            value="${message(code:'is.button.update')}"
            before='if (\$.icescrum.uploading()) {${is.notice(text:message(code:"is.upload.inprogress.wait"))} return false; }'
            history="${referrer?.controller ?'false': 'true'}"/>
    <is:button
            targetLocation="${referrer?.controller ?: 'productBacklog' + referrer?.action ?'/'+referrer?.action:''+ referrer?.id ?'/'+referrer?.id:''}"
            id="cancelForm"
            type="link"
            button="button-s button-s-black"
            remote="true"
            url="[controller:referrer?.controller ?: 'productBacklog', action:referrer?.action ?: 'list', id:referrer?.id?:'', params:[product:params.product]]"
            update="window-content-${referrer?.controller ?: id}"
            value="${message(code: 'is.button.cancel')}"/>
  </is:buttonBar>

</g:form>
<jq:jquery>
  $("#storyname").focus();
  jQuery("#window-content-${referrer?.controller ?: id}").addClass('window-content-toolbar');
  <is:renderNotice />
</jq:jquery>
<is:shortcut key="shift+return" callback="\$('#submitAndContinueForm').click();" scope="${id}" listenOn="'#${id}-form, #${id}-form input'"/>
<is:shortcut key="return" callback="if(e.currentTarget.id == 'story-textAs'){return false;}\$('#submitForm').click();" scope="${id}" listenOn="'#${id}-form, #${id}-form input'"/>
<is:shortcut key="esc" callback="\$.icescrum.cancelForm();" scope="${id}" listenOn="'#${id}-form, #${id}-form input'"/>