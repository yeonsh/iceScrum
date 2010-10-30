<is:objectAsXML object ="${object}" node="product" root="${root}">
  <is:propertyAsXML
          name="['name','pkey','planningPokerGameType','startDate','endDate']"/>
  <is:propertyAsXML
          name="['description']"
          cdata="true"/>
  <is:propertyAsXML
          object ="preferences"
          name="['newTeams','lockPo','hidden','url','noEstimation','autoDoneStory','displayRecurrentTasks','displayUrgentTasks','assignOnCreateTask','assignOnBeginTask','autoCreateTaskOnEmptyStory','limitUrgentTasks','estimatedSprintsDuration']"/>
  <% session.progress?.updateProgress(10,message(code:'is.export.inprogress', args:[message(code:'is.team')])) %>
  <is:listAsXML
          name="teams"
          template="/export/xml/team"
          deep="['team','user']"
          child="team"/>
  <% session.progress?.updateProgress(20,message(code:'is.export.inprogress', args:[message(code:'is.release')])) %>
  <is:listAsXML
          name="releases"
          child="release"
          deep="['release','sprint','task','cliche','story']"
          template="/export/xml/release"/>
  <% session.progress?.updateProgress(30,message(code:'is.export.inprogress', args:[message(code:'is.actor')])) %>
  <is:listAsXML
          name="actors"
          child="actor"
          template="/export/xml/actor"
          deep="['actor']"/>
  <% session.progress?.updateProgress(40,message(code:'is.export.inprogress', args:[message(code:'is.feature')])) %>
  <is:listAsXML
          name="features"
          child="feature"
          template="/export/xml/feature"
          deep="['feature']"/>
  <% session.progress?.updateProgress(50,message(code:'is.export.inprogress', args:[message(code:'is.story')])) %>
  <is:listAsXML
          expr="${{it.parentSprint == null}}"
          name="stories"
          template="/export/xml/story"
          child="story"
          deep="['story','task']"/>
  <% session.progress?.updateProgress(80,message(code:'is.export.inprogress', args:[message(code:'is.cliche')])) %>
  <is:listAsXML
          name="cliches"
          template="/export/xml/cliche" 
          child="cliche"/>
  <is:listAsXML
          name="productOwners"
          template="/export/xml/user"
          deep="true"
          child="productOwner"/>
</is:objectAsXML>
