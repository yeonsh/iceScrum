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
-
- Authors:
-
- Stephane Maldini (manuarii.stein@icescrum.com)
--}%
<form id="form-team-join" name="form-team-join" method="post" >
<is:browser detailsLabel="is.ui.autocompletechoose.teams.details"
        browserLabel="is.ui.autocompletechoose.teams"
        controller="team"
        titleLabel="is.dialog.team.general.title"
        actionColumn="joinList"
        name="team-join" >
</is:browser>
</form>