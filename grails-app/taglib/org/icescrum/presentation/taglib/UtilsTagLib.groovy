  /*
 * Copyright (c) 2010 iceScrum Technologies.
 *
 * This file is part of iceScrum.
 *
 * iceScrum is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License.
 *
 * iceScrum is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.icescrum.presentation.taglib
import grails.converters.JSON
import org.icescrum.components.UtilsWebComponents
import org.springframework.web.servlet.support.RequestContextUtils as RCU

  class UtilsTagLib {

  static namespace = 'is'

  def grailsApplication

  def loadJSContext = { attrs, body ->
    def opts = ''
    def currentProduct
    if (params.product) {
      currentProduct = pageScope.product
      opts = """currentProductName :'${currentProduct.name}',"""

    }
    def p = []
    def widgetsList = session.widgetsList
    def controllerSpace = 'scrumOS'
    if (params.product) {
      p = [product: currentProduct.id]
    } else if (params.team) {
      p = [team: params.team]
      controllerSpace = 'team'
      widgetsList = session.widgetsTeamList
    }
    def locale = attrs.locale ? attrs.locale.replace('_', '-') : RCU.getLocale(request).toString().replace('_', '-')
    def jsCode = """\$.icescrum.init({
                          baseUrl: "${createLink(controller: controllerSpace)}",
                          baseUrlProduct: "${createLink(controller: controllerSpace, params: p)}${p ? '/' : ''}",
                          ${opts}
                          urlOpenWidget:"${createLink(controller: controllerSpace, action: 'openWidget', params: p)}",
                          urlCloseWidget:"${createLink(controller: controllerSpace, action: 'closeWidget', params: p)}",
                          urlOpenWindow:"${createLink(controller: controllerSpace, action: 'openWindow', params: p)}",
                          urlCloseWindow:"${createLink(controller: controllerSpace, action: 'closeWindow', params: p)}",
                          deleteConfirmMessage:"${message(code: 'is.confirm.delete').encodeAsJavaScript()}",
                          cancelFormConfirmMessage:"${message(code: 'is.confirm.cancel.form').encodeAsJavaScript()}",
                          acceptedState:"${message(code: 'is.story.state.accepted').encodeAsJavaScript()}",
                          estimatedState:"${message(code: 'is.story.state.estimated').encodeAsJavaScript()}",
                          widgetsList:${widgetsList as JSON ?: []},
                          locale:'${locale}',
                          dialogErrorContent:"<div id=\'window-dialog\'><form method=\'post\' class=\'box-form box-form-250 box-form-250-legend\'><div  title=\'${message(code: 'is.dialog.sendError.title')}\' class=\' panel ui-corner-all\'><h3 class=\'panel-title\'>${message(code: 'is.dialog.sendError.title')}</h3><p class=\'field-information\'>${message(code: 'is.dialog.sendError.description')}</p><p class=\'field-area clearfix field-noseparator\' for=\'stackError\' label=\'${message(code: 'is.dialog.sendError.stackError')}\'><label for=\'stackError\'>${message(code: 'is.dialog.sendError.stackError')}</label><span class=\'area area-large\' id=\'stackError-field\'><span class=\'start\'></span><span class=\'content\'><textarea id=\'stackError\' name=\'stackError\' ></textarea></span><span class=\'end\'></span></span></p><p class=\'field-area clearfix field-noseparator\' for=\'comments\' label=\'${message(code: 'is.dialog.sendError.comments')}\'><label for=\'comments\'>${message(code: 'is.dialog.sendError.comments')}</label><span class=\'area area-large\' id=\'comments-field\'><span class=\'start\'></span><span class=\'content\'><textarea id=\'comments\' name=\'comments\' ></textarea></span><span class=\'end\'></span></span></p></div></form></div>"
                });
                \$.icescrum.initHistory();"""
    out << jq.jquery(null, jsCode)
  }

  def quickLook = { attrs ->
    def params = [
            action:"index",
            controller:"quickLook",
            width:"600",
            resizable:"false",
            draggable:"false",
            withTitlebar:"false",
            buttons:"'${message(code:'is.button.close')}': function() { \$(this).dialog('close'); }",
            focusable:false,
            params:attrs.params
    ]
    out << is.remoteDialogFunction(params)
  }

  /**
   * Generate the iceScrum desktop (where the main window appear)
   */
  def desktop = { attrs, body ->
    out << '<div id="main">'
    out << '<div id="main-content">'
    out << body()
    out << '</div>'
    out << '</div>'
  }

  def simpleDesktop = { attrs, body ->
    out << '<div id="main-simple">'
    out << '<div id="main-content">'
    out << body()
    out << '</div>'
    out << '</div>'
  }

  def changeRank = { attrs, body ->

    if (attrs.params && attrs.params instanceof Map)
      attrs.addParams = "params = params+'&${UtilsWebComponents.createQueryString(attrs.params)}';"
    else if (attrs.params)
      attrs.addParams = "params = params+'${attrs.params}';"
    out << """\$.icescrum.changeRank('${attrs.selector}', this, ${attrs.ui?:'ui.item'}, function(params, ui) { ${attrs.addParams?:''}
    ${
      remoteFunction(
              action: attrs.action,
              controller: attrs.controller,
              id: attrs.id,
              params: 'params',
              onFailure: "\$(ui).sortable(\"cancel\");" + attrs.onFailure)
    }})"""
  }

  /**
   * Generate iceScrum main menu (project dropMenu, avatar, roles, logout, ...)
   */
  def mainMenu = { attrs, body ->
    out << g.render(template: '/scrumOS/navigation')
  }

  def renderNotice = {attrs ->
    def notice = attrs.remove('notice') ?: 'notice'
    def noticeAttrs = request."$notice" ?: flash."$notice"
    if (noticeAttrs)
      out << is.notice(noticeAttrs)
  }

  def renderJavascript = {attrs ->
    def javascript = attrs.remove('javascript') ?: 'javascript'
    def js = request."$javascript" ?: flash."$javascript"
    if (js){
      println js
      out << js
    }
  }

  def savedRequest = {attrs, body ->
    if (params.ref) {
      out << params.ref.decodeURL()
    } else if (session.SPRING_SECURITY_SAVED_REQUEST_KEY)
      out << session.SPRING_SECURITY_SAVED_REQUEST_KEY.requestURL
    else
      out << createLink(uri: '/')
  }

  def bundleFromController = {attrs, body ->
    def controllerRequested = "${controllerName}Controller"
    def controller = grailsApplication.uIControllerClasses.find { it.shortName.toLowerCase() == controllerRequested.toLowerCase()}
    out << g.message(code: controller.getPropertyValue(attrs.bundle).get(attrs.value))
  }

  def tooltipSprint = { attrs ->

    def hideText
    def hideBorder

    if (!attrs.text) {
      hideText = "qtip-text-hidden"
      hideBorder = "{'border':'none'}"
    }

    def params = [
            for: "#event-id-${attrs.id} .event-header-label",
            contentTitleText: attrs.title,
            contentText: attrs.text,
            styleName: "icescrum",
            positionTarget: "\'mouse\'",
            positionAdjustMouse: "false",
            positionAdjustX: "5",
            positionAdjustY: "5",
            showSolo: "true",
            showDelay: "500",
            hideDelay: "0",
            styleTitle: hideBorder ?: null,
            apiBeforeShow: """function(){ if(\$('#dropmenu').is(':visible')){return false;}}""",
            styleClassesContent: hideText ?: null,
            hideWhenEvent: "mouseleave",
            positionContainer: attrs.container
    ]
    out << is.tooltip(params)
  }

  def tooltipPostit = { attrs ->

    def hideText
    def hideBorder

    if (!attrs.text) {
      hideText = "qtip-text-hidden"
      hideBorder = "{'border':'none'}"
    }

    def params = [
            for: "#postit-${attrs.type}-${attrs.id}",
            contentTitleText: attrs.title?.decodeHTML(),
            contentText: attrs.text,
            styleName: "icescrum",
            positionTarget: "\'mouse\'",
            positionAdjustMouse: "false",
            positionAdjustScreen: "true",
            positionAdjustX: "10",
            positionAdjustY: "10",
            styleTypeSizeY:"200",
            showSolo: "true",
            showDelay: "500",
            hideDelay: "0",
            styleTitle: hideBorder ?: null,
            styleClassesContent: hideText ?: null,
            hideWhenEvent: "mouseleave",
            positionContainer: attrs.container,
            apiBeforeShow: "function(){${attrs.apiBeforeShow}}"
    ]
    out << is.tooltip(params)
  }

  def avatar = { attrs, body ->
    assert attrs.userid
    def avat = new File(grailsApplication.config.icescrum.images.users.dir+attrs.userid+'.png')
    if (avat.exists()){
      out << "<img src='${createLink(controller:'user',action:'avatar',id:attrs.userid)}${attrs.nocache?'?nocache='+new Date().getTime():''}' ${attrs.elementId?'id=\''+attrs.elementId+'\'':''} class='avatar avatar-user-${attrs.userid} ${attrs."class"?attrs."class":''}' title='${message(code:"is.user.avatar")}' alt='${message(code:"is.user.avatar")}'/>"
    }else{
      out << r.img(
            id:attrs.elementId?:'',
            uri:"/${is.currentThemeImage()}avatars/avatar.png",
            class:"avatar avatar-user-${attrs.userid} ${attrs."class"?attrs."class":''}",
            title:message(code:"is.user.avatar"),
            alt:message(code:"is.user.avatar")
      )
    }
  }

  def avatarSelector = {
    def avatarsDir = grailsApplication.parentContext.getResource(is.currentThemeImage().toString()+'avatars').file
    if (avatarsDir.isDirectory()){
      out << "<span class=\"selector-avatars\">"
      avatarsDir.listFiles().each{
        if (it.name.endsWith('.png')){
          out << """<span>
                      <img rel='${it.name}' src=\"${createLink(uri:'/'+is.currentThemeImage())}avatars/${it.name}\" onClick=\"jQuery('#preview-avatar').attr('src',jQuery(this).attr('src'));jQuery('#avatar-selected').val(jQuery(this).attr('rel'));jQuery('#avatar-field input.is-multifiles-uploaded').val('');\"/>
                    </span>"""
        }
      }
      out << "<input type='text' style='display:none;' id='avatar-selected' name='avatar-selected'/>"
      out << "</span>"
    }
  }
}
