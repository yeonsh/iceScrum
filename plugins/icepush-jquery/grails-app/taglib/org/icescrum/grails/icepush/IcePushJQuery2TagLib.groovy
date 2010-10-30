package org.icescrum.grails.icepush

class IcePushJQuery2TagLib {

  static namespace = "icep"
  def grailsApplication

  def bridge = {attrs, body ->
    if (grailsApplication.config.icepush?.disabled)
      return
    out << """<script type="text/javascript" src="${resource(dir:'/', file: 'code.icepush')}"></script>"""
    out << """<script type="text/javascript" src="${resource(plugin:'icepush-jquery', dir: '/js/', file: 'jquery.icepush.js')}"></script>"""
  }

  def notifications = { attrs, body ->
    if (grailsApplication.config.icepush?.disabled)
      return

    assert attrs.name

    if (!attrs.callback && !attrs.reload)
      return


    def callback = attrs.disabled ? "if(${attrs.disabled}){" : ""
    callback += attrs.before?attrs.before+';':""
    callback += attrs.callback?attrs.callback+';':""

    if (attrs.reload){
      assert attrs.reload.update
      callback += "jQuery('${attrs.reload.remove('update')}').load('${g.createLink(attrs.reload)}',${attrs.reload.textStatus?:'[]'}${attrs.reload.onComplete?','+attrs.reload.onComplete:''})"
    }

    callback += attrs.disabled? "}" :""

    def callbackVar = "callbackPushListener${attrs.name}"
    def jqCode = """
                  var ${callbackVar} = function(){${callback}};
                  jQuery.push.listenToGroup('${attrs['group']}',${callbackVar},'${attrs.name}');
                 """

    attrs.autoleave = attrs.autoleave ? attrs.autoleave.toBoolean() : true
    if (attrs.autoleave){
      assert attrs.listenOn
      jqCode += """jQuery('${attrs.listenOn}').bind('remove.icespush',function(){
                          jQuery.push.stopListeningToGroup('${attrs['group']}',${callback?callbackVar:'null'},'${attrs.name}');
                   });"""
    }
    out << "jQuery(function(){${jqCode}});"
  }

  def stopNotifications = { attrs, body ->
    if (grailsApplication.config.icepush?.disabled)
      return

    def jqCode = "jQuery.push.stopListeningToGroup('${attrs['group']}',${attrs['callback']?attrs['callback']:'null'});"
    out << """jQuery(function(){${jqCode}});"""
  }

  def push = {attrs, body ->
    if (grailsApplication.config.icepush?.disabled)
      return
    def pc = org.icepush.PushContext.getInstance(servletContext)
    pc.push(attrs['group'])
  }

  def pushFromClient = {attrs, body ->
    if (grailsApplication.config.icepush?.disabled)
      return
    out << "ice.push.notify('${attrs['group']}')"
  }

}