package org.icescrum.core.services

import grails.util.Environment
import org.icescrum.core.security.AuthorityManager
import org.icescrum.core.support.ApplicationSupport
import org.icescrum.core.test.DummyPopulator

class BootStrapService {

  void start() {

    AuthorityManager.initSecurity()
    ApplicationSupport.generateFolders()

    if (Environment.current == Environment.DEVELOPMENT)
      DummyPopulator.dummyze()
  }
}
