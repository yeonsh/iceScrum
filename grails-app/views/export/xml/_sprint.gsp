<is:objectAsXML object ="${object}" node="sprint" indentLevel="${indentLevel}" root="${root}">
  <is:propertyAsXML name="['state','dailyWorkTime','velocity','capacity','resource','endDate','startDate','orderNumber']"/>
  <is:propertyAsXML name="['retrospective','doneDefinition','description','goal']" cdata="true"/>
  <is:listAsXML
          name="tasks"
          template="/export/xml/task"
          indentLevel="${indentLevel + 1}" 
          expr="${{it.parentStory == null}}"/>
  <is:listAsXML
          name="stories"
          template="/export/xml/story"
          deep="${deep}"
          child="story"
          indentLevel="${indentLevel + 1}"/>
  <is:listAsXML
        name="cliches"
        template="/export/xml/cliche"
        child="cliche"
        deep="${deep}"
          indentLevel="${indentLevel  + 1}"/>
</is:objectAsXML>