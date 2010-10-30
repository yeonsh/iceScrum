<form class="box-form box-form-160 box-form-160-legend">
  <input type="hidden" value="${params.product}" name="product"/>
  <is:fieldset title="is.dialog.acceptAs.title">
      <is:fieldRadio for="acceptAs" label="is.dialog.acceptAs.acceptAs.title" noborder="true">
        <g:if test="${sprint}">
          <is:radio from="[(message(code: 'is.story')): '0', (message(code: 'is.feature')): '1', (message(code: 'is.task.type.urgent')): '2']" id="acceptAs" value="0" name="acceptAs"/>
        </g:if>
        <g:else>
          <is:radio from="[(message(code: 'is.story')): '0', (message(code: 'is.feature')): '1']" id="acceptAs" value="0" name="acceptAs"/>
        </g:else>
      </is:fieldRadio>
  </is:fieldset>
</form>