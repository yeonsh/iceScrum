package org.icescrum.web.presentation.app

import org.icescrum.web.support.MenuBarSupport
import grails.plugins.springsecurity.Secured

@Secured('ROLE_ADMIN')
class AdminController {

    static final id = 'admin'
    static ui = true
    static menuBar = MenuBarSupport.noTeamOrProductDynamicBar('is.ui.admin',id , true, false)
    static window =  [title:'is.ui.admin',help:'is.ui.admin.help',toolbar:false]

    def index = {
      render 'test'
    }
}
