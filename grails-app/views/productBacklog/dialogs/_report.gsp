<div class="box-form">
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

<is:fieldset title="is.dialog.report.generation">
      <is:fieldInformation noborder="true">
        <g:message code="is.dialog.report.description"/>
      </is:fieldInformation>
       <is:progressBar
              elementId="progress"
              label="${message(code:'is.report.processing')}"
              iframe="true"
              showOnCreate="true"
              iframeSrc="${createLink(action:'print',controller:'productBacklog',params:[product:params.product,get:true,format:params.format])}"
              url="${createLink(action:'print',controller:'productBacklog',params:[product:params.product,status:true])}"
              />
  </is:fieldset>
</div>