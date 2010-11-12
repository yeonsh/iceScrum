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
-
- Authors:
-
- Vincent Barrier (vincent.barrier@icescrum.com)
- Damien vitrac (damien@oocube.com)
- Manuarii Stein (manuarii.stein@icescrum.com)
- Stephane Maldini (manuarii.stein@icescrum.com)
--}%
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <title>iceScrum -
<g:layoutTitle/></title>
  <link rel="shortcut icon" href="${r.resource(dir: is.currentThemeImage(), file: 'favicon.ico')}" type="image/x-icon"/>
  <!--[if IE 8]><meta http-equiv="X-UA-Compatible" content="IE=8"/><![endif]-->
  <r:use modules="jquery-ui, datepicker-locales, resize, qtip, pnotify, ui-selectmenu, hotkeys, history, mousewheel, eventline, dotimeout, jqplot,
   browser, table, dropmenu, jeditable, progress, input, checkbox, alphanumeric, markitup, scrollbar" />
  <r:use module="icescrum"/>
  <sec:ifLoggedIn>
    <r:use modules="dnd, ui-jeditable"/>
    <script src="${resource(dir:'js/timeline/timeline_ajax', file:'simile-ajax-api.js?bundle=true')}" type="text/javascript"></script>
    <script src="${resource(dir:'js/timeline/timeline_js', file:'timeline-api.js?bundle=true')}" type="text/javascript"></script>
    <script src="${resource(dir:'js/timeline', file:'icescrum-painter.js')}" type="text/javascript"></script>
  </sec:ifLoggedIn>
  <r:layoutResources />
  <icep:bridge/>
  <g:layoutHead/>
</head>
<body class="icescrum">
<div id="application">
  <div id="head" class="${product ? 'is_header-normal' : 'is_header-full'}">
    <is:mainMenu/>
  </div>
  <div id="local">
    <is:widgetBar/>
  </div>
  <is:desktop>
    <g:layoutBody/>
  </is:desktop>
</div>
<is:loadJSContext/>
<is:shortcut key="ctrl+shift+n" callback="${is.remoteDialogFunction(action:'openWizard',controller:'project',title:'is.dialog.wizard',resizable:'false',width:'760',height:'460',draggable:'false')}"/>
<is:spinner
        on401="document.location='${createLink(controller:'login')}?ref=${params.product?'p/'+product.pkey:params.team?'t/'+params.team:''}'+document.location.hash.replace('#','@');"
        on400="${is.notice(data:'$.parseJSON(xhr.responseText)',type:'error')}"
        on403="${is.notice(text:message(code:'is.error.denied'),type:'error')}"
        on500="\$.icescrum.dialogError(xhr.responseText)"/>
<jq:jquery>
  $("#main-content").droppable({
    drop:function(event, ui){
      var id = ui.draggable.attr('id').replace('widget-id-','');
      if (id == ui.draggable.attr('id')){
        id = ui.draggable.attr('id').replace('elem_','');
      }
      $.icescrum.openWindow(id);
    },
    hoverClass: 'main-active',
    accept: '.draggable-to-desktop'
  });
  <g:if test="${flash.message}">
    <is:notice text="${message(code: flash.message)}"/>
  </g:if>
</jq:jquery>
<r:layoutResources />
</body>
</html>