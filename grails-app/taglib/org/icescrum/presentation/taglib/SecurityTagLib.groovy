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

import org.springframework.security.core.context.SecurityContextHolder as SCH

import org.codehaus.groovy.grails.plugins.springsecurity.GrailsUser
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.authority.GrantedAuthorityImpl
import org.icescrum.core.domain.Product
import org.icescrum.core.domain.Team
import org.icescrum.core.domain.security.Authority

class SecurityTagLib {
  static namespace = 'is'

  def securityService
  def aclUtilService
  static final userAuthorities = [new GrantedAuthorityImpl(Authority.ROLE_USER)]

  def displayRole = {attrs ->
    def res = []
    def user = attrs.remove('user')

    if (!user) {
      if (SpringSecurityUtils.ifAllGranted(Authority.ROLE_ADMIN)) {
        res << message(code: 'is.role.admin')
      } else {
        if (securityService.scrumMaster(attrs.team, SCH.context.authentication)) {
          res << message(code: 'is.role.scrumMaster')
        }
        if (securityService.teamMember(attrs.team, SCH.context.authentication)) {
          res << message(code: 'is.role.teamMember')
        }
        if (securityService.productOwner(attrs.product, SCH.context.authentication)) {
          res << message(code: 'is.role.productOwner')
        }
        if (securityService.owner(null, SCH.context.authentication)) {
          res << message(code: 'is.role.owner')
        }
        if (!res && securityService.stakeHolder(attrs.product, SCH.context.authentication)) {
          res << message(code: 'is.role.stakeHolder')
        }
      }
    } else {
      if (securityService.hasRoleAdmin(user)) {
        res << message(code: 'is.role.admin')
      } else {
        def grailsUser = new GrailsUser(user.username, '', user.enabled, true, true, true, userAuthorities, user.id)
        def auth = new UsernamePasswordAuthenticationToken(grailsUser, null, userAuthorities as GrantedAuthority[])
        if (securityService.isScrumMaster(attrs.team, auth)) {
          res << message(code: 'is.role.scrumMaster')
        }
        if (securityService.isProductOwner(attrs.product, auth)) {
          res << message(code: 'is.role.productOwner')
        }
        if (attrs.product && securityService.isOwner(attrs.product, auth, Product)) {
          res << message(code: 'is.role.owner')+' ('+message(code:'is.product')+')'
        }
        if (attrs.team && securityService.isOwner(attrs.team, auth, Team)) {
          res << message(code: 'is.role.owner')+' ('+message(code:'is.team')+')'
        }

      }
    }
    out << res.join(', ')
  }


}