package org.icescrum.web.security

import javax.servlet.http.HttpServletRequest
import org.codehaus.groovy.grails.plugins.springsecurity.RequestHolderAuthenticationFilter


class ScrumAuthenticationProcessingFilter extends RequestHolderAuthenticationFilter {
  @Override
  protected String obtainPassword(HttpServletRequest request) {
     String password = super.obtainPassword(request)
     if (password) {
        request.session[SPRING_SECURITY_FORM_PASSWORD_KEY] = password
     }
     return password
  }
}
