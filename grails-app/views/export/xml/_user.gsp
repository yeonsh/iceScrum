<is:objectAsXML object ="${object}" node="user" indentLevel="${indentLevel}" root="${root}">
  <is:propertyAsXML name="['username','password','email','dateCreated','enabled','accountExpired','accountLocked','passwordExpired']"/>
  <is:propertyAsXML name="['lastName','firstName']" cdata="true"/>
  <is:propertyAsXML
            object ="preferences"
            name="['language','activity','filterTask','menu','menuHidden']"/>
  <is:listAsXML name="teams" template="/export/xml/team" child="team" deep="false" indentLevel="${indentLevel  + 1}"/>
</is:objectAsXML>