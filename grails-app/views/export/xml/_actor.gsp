<is:objectAsXML object ="${object}" node="actor" indentLevel="${indentLevel}" root="${root}">
  <is:propertyAsXML name="['name','instances','expertnessLevel','useFrequency','creationDate']"/>
  <is:propertyAsXML name="['satisfactionCriteria','notes','description']" cdata="true"/>
  <is:listAsXML name="stories" template="/export/xml/story" child="story" deep="${deep}" indentLevel="${indentLevel}"/>
</is:objectAsXML>