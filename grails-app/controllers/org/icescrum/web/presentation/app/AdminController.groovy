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
 *
 * Authors:
 *
 * Vincent Barrier (vincent.barrier@icescrum.com)
 *
 */

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
