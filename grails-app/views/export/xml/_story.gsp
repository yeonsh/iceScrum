<is:objectAsXML object ="${object}" node="story" indentLevel="${indentLevel}" root="${root}">
  <is:propertyAsXML name="['name','state','suggestedDate','acceptedDate','estimatedDate','plannedDate','inProgressDate','doneDate','effort','value','rank','creationDate','type','executionFrequency']"/>
  <is:propertyAsXML name="['textAs','textICan','textTo','notes','description']" cdata="true"/>
  <is:propertyAsXML object="creator"/>
  <is:propertyAsXML object="feature"/>
  <is:propertyAsXML object="actor"/>
  <is:listAsXML
          name="tasks"
          template="/export/xml/task"
          child="task"
          deep="${deep}"
          indentLevel="${indentLevel + 1}"/>
</is:objectAsXML>