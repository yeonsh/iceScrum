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
- Vincent Barrier (vincent.barrier@icescrum.com)
--}%<is:objectAsXML object ="${object}" node="feature" indentLevel="${indentLevel}" root="${root}">
  <is:propertyAsXML name="['name','color','value','type','rank','creationDate']"/>
  <is:propertyAsXML name="['notes','description']" cdata="true"/>
  <is:listAsXML
          name="stories"
          template="/export/xml/story"
          child="story" 
          deep="${deep}"
          indentLevel="${indentLevel + 1}"/>
</is:objectAsXML>