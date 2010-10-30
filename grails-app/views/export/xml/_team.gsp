<is:objectAsXML object ="${object}" node="team" indentLevel="${indentLevel}" root="${root}">
  <is:propertyAsXML name="['name','velocity','dateCreated']"/>
  <is:propertyAsXML name="['description']" cdata="true"/>
    <is:propertyAsXML
            object ="preferences"
            name="['allowNewMembers','allowRoleChange']"/>
  <is:listAsXML name="members" template="/export/xml/user" child="user" deep="${deep}" indentLevel="${indentLevel  + 1}"/>
  <is:listAsXML name="scrumMasters" template="/export/xml/user" deep="false" child="scrumMaster" indentLevel="${indentLevel  + 1}"/>
</is:objectAsXML>