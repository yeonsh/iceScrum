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

%{-- Releases lists --}%
<li>
  <is:select
          container="#window-title-bar-content-${id}"
          width="160"
          rendered="${releases*.name.size() > 0}"
          maxHeight="100"
          styleSelect="dropdown"
          class="window-toolbar-selectmenu-button window-toolbar-selectmenu"
          from="${releases*.name}"
          keys="${releases*.id}"
          name="release" value="${params.id}"
          history='false'
          onchange="\$.icescrum.openWindow('${id}/'+this.value)"/>
</li>