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
  --}%

<is:backlogElementLayout
        id="window-${id}"
        selectable="[restrictOnAccess:'productOwner()',
                    filter:'div.postit-story',
                    cancel:'.postit .postit-sortable, a, .mini-value, select, input',
                    selected:'\$.icescrum.dblclickSelectable(ui,300,function(obj){'+is.quickLook(params:'\'story.id=\'+\$(obj.selected).icescrum(\'postit\').id()')+';})',
                    onload:'\$(\'.window-toolbar\').icescrum(\'toolbar\', \'buttons\', 0).toggleEnabled(\'.backlog\');']"
        sortable='[restrictOnAccess:"productOwner()",
                  handle:".postit-sortable",
                  placeholder:"postit-placeholder ui-corner-all"]'
        droppable='[selector:".postit",
                  hoverClass: "ui-selected",
                  drop: remoteFunction(controller:"productBacklog",
                                       action:"associateFeature",
                                       update:"window-content-${id}",
                                       params:"\"product="+params.product+"&feature.id=\"+ui.draggable.attr(\"elemId\")+\"&story.id=\"+\$(\".postit-layout .postit-id\", \$(this)).text()"
                                       ),
                  accept: ".postit-row-feature"]'
        dblclickable='[restrictOnNotAccess:"productOwner()", 
                       selector:".postit",
                       callback:is.quickLook(params:"\"story.id=\"+obj.attr(\"elemId\")")]'

        changeRank='[selector:".postit",controller:id,action:"changeRank",params:[product:params.product]]'
        editable="[controller:id,
                  action:'estimate',
                  on:'.mini-value',
                  restrictOnNotAccess:'teamMember() or scrumMaster()',
                  findId:'\$(this).parent().parent().parent().attr(\'elemID\')',
                  type:'selectui',
                  before:'$(this).next().hide();',
                  cancel:'\$(original).next().show();',
                  values:suiteSelect,
                  callback:'if (value == \'?\'){\$(this).next().html(\''+message(code:'is.story.state.accepted')+'\');}else{\$(this).next().html(\''+message(code:'is.story.state.estimated')+'\')} $(this).next().show();',
                  params:[product:params.product]]"
        value="${stories}"
        var="story">

  <is:postit id="${story.id}"
          miniId="${story.id}"
          title="${story.name}"
          attachment="${story.totalAttachments}"
          styleClass="story type-story-${story.type}"
          type="story"
          typeName="${story.type}"
          miniValue="${story.effort >= 0 ? story.effort :'?'}"
          color="${story.feature?.color}"
          stateText="${is.bundleFromController(bundle:'stateBundle',value:story.state)}"
          sortable='[restrictOnAccess:"productOwner()"]'
          controller="productBacklog"
          comment="${story.totalComments >= 0 ? story.totalComments : ''}">
    <is:truncated size="60"><is:storyTemplate story="${story}" /></is:truncated>

    %{--Embedded menu--}%

    <is:postitMenu
            id="${story.id}"
            contentView="window/postitMenu"
            params="[
                  id:id,
                  story:story,
                  type:'story',
                  miniValueClick:sec.access(expression:'scrumMaster() or teamMember()',
                                            remoteFunction(
                                              action:'estimate',
                                              id:story.id,
                                              params:'{selectedValue:selectedValue}')),
                  miniValue:(story.effort?:'?')
                  ]"
            />

    <g:if test="${story.name?.length() > 17 || is.storyTemplate(story:story).length() > 65}">
      <is:tooltipPostit
              type="story"
              id="${story.id}"
              title="${story.name}"
              text="${is.storyTemplate(story:story)} "
              apiBeforeShow="if(\$('#dropmenu').is(':visible') || \$('#postit-select-suite').is(':visible')){return false;}"
              container="\$('#window-id-${id}')"/>
    </g:if>
  </is:postit>
</is:backlogElementLayout>
<jq:jquery>
  jQuery("#window-content-${id}").removeClass('window-content-toolbar');
  if(!jQuery("#dropmenu").is(':visible')){
    jQuery("#window-id-${id}").focus();
  }
  <is:renderNotice />
  <icep:notifications
        name="${id}Window"
        reload="[update:'#window-content-'+id,action:'list',params:[product:params.product]]"
        disabled="!jQuery('#backlog-layout-window-${id}, .view-table').is(':hidden')"
        group="${params.product}-${id}"
        listenOn="#window-content-${id}"/>
</jq:jquery>
<is:shortcut key="space" callback="if(\$('#dialog').dialog('isOpen') == true){\$('#dialog').dialog('close'); return false;}\$.icescrum.dblclickSelectable(null,null,function(obj){${is.quickLook(params:'\'story.id=\'+jQuery(obj.selected).icescrum(\'postit\').id()')}},true);" scope="${id}"/>
<is:shortcut key="ctrl+a" callback="\$('#backlog-layout-window-${id} .ui-selectee').addClass('ui-selected');"/>