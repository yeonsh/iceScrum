<is:objectAsXML object ="${object}" node="task" indentLevel="${indentLevel}" root="${root}">
  <is:propertyAsXML name="['name','estimation','type','state','rank','creationDate','inProgressDate','doneDate']"/>
  <is:propertyAsXML object="creator"/>
  <is:propertyAsXML object="responsible"/>
  <is:propertyAsXML name="['description','notes']" cdata="true"/>
</is:objectAsXML>