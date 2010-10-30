<is:objectAsXML object ="${object}" node="release" indentLevel="${indentLevel}" root="${root}">
  <is:propertyAsXML name="['name','state','releaseVelocity','endDate','startDate','orderNumber']"/>
  <is:propertyAsXML name="['vision','description','goal']" cdata="true"/>
  <is:listAsXML
          name="sprints"
          template="/export/xml/sprint"
          child="sprint"
          deep="${deep}"
          indentLevel="${indentLevel + 1}"/>
  <is:listAsXML
        name="cliches"
        template="/export/xml/cliche"
        deep="${deep}"
        indentLevel="${indentLevel  + 1}"
        child="cliche"/>
</is:objectAsXML>