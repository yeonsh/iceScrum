<is:objectAsXML object ="${object}" node="feature" indentLevel="${indentLevel}" root="${root}">
  <is:propertyAsXML name="['name','color','value','type','rank','creationDate']"/>
  <is:propertyAsXML name="['notes','description']" cdata="true"/>
  <is:listAsXML
          name="stories"
          template="/export/xml/story"
          child="story" 
          deep="${deep}"
          indentLevel="${indentLevel + 1}"/>
</is:objectAsXML>