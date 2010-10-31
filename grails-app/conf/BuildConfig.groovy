import org.codehaus.groovy.grails.cli.GrailsScriptRunner
import grails.util.GrailsNameUtils
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



grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.war.file = "target/${appName}.war"

grails.plugin.location.'icescrum-core-domain' =  'plugins/icescrum-core-domain'
grails.plugin.location.'icescrum-core-services' =  'plugins/icescrum-core-services'
grails.plugin.location.'icescrum-core-webcomponents' =  'plugins/icescrum-core-webcomponents'

grails.plugin.location.'fluxiable' =  'plugins/fluxiable'
grails.plugin.location.'attachmentable' =  'plugins/attachmentable'
grails.plugin.location.'icepush-jquery' =  'plugins/icepush-jquery'

coverage {
  exclusions = ["org/grails/**","**/*BuildConfig*","org/icescrum/web/presentation/**"]
}

grails.project.dependency.resolution = {
  // inherit Grails' default dependencies
  inherits("global") {
    // uncomment to disable ehcache
    // excludes 'ehcache'
  }
  log "warn" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
  repositories {
    grailsPlugins()
    grailsCentral()
    grailsHome()

    // uncomment the below to enable remote dependency resolution
    // from public Maven repositories
    //mavenLocal()
    mavenCentral()
    //mavenRepo "http://snapshots.repository.codehaus.org"
    mavenRepo "http://repository.codehaus.org"
  }

//  plugins {
//	runtime ':cached-resources:latest.integration'
//  }
  
  dependencies {
    // specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes eg.
    test 'xmlunit:xmlunit:1.3'
  }

  grails.war.resources = { stagingDir ->
    copy(todir: "${stagingDir}/WEB-INF/classes") {
      fileset(dir: "src/java") {
        include(name: "**/*.properties")
      }
    }
    copy(todir: "${stagingDir}/WEB-INF/classes/grails-app/i18n", encoding:"utf-8") {
      fileset(dir: "grails-app/i18n") {
        include(name: "report*")
      }
    }
  }
}

//iceScrum plugins management
def iceScrumPluginsDir = System.getProperty("icescrum.plugins.dir")?:false
println "Compile and use icescrum plugins : ${iceScrumPluginsDir?true:false}"

if (iceScrumPluginsDir){
  iceScrumPluginsDir.split(";").each {
    File dir = new File(it.toString())
    println "Scanning plugin dir : ${dir.canonicalPath}"

    if (dir.exists()){
      File descriptor = dir.listFiles(new FilenameFilter() {
            public boolean accept(File file, String s) {
                return s.endsWith("GrailsPlugin.groovy");
            }
      })[0] ?: null;

      if (descriptor){
        String name = GrailsNameUtils.getPluginName(descriptor.getName());
        println "found plugin : ${name}"
        grails.plugin.location."${name}" =  "${it}"
      }
    }else{
      println "no plugin found in dir"
    }

  }
}