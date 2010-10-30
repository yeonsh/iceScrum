/*
 * Copyright (c) 2010 iceScrum Technologies.
 *
 * This file is part of iceScrum.
 *
 * iceScrum is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License.
 *
 * iceScrum is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.icescrum.core.services.test

import grails.test.GrailsUnitTestCase

import java.text.SimpleDateFormat
import org.icescrum.core.domain.Actor
import org.icescrum.core.domain.Cliche
import org.icescrum.core.domain.Feature
import org.icescrum.core.domain.Impediment
import org.icescrum.core.domain.Product
import org.icescrum.core.domain.Release
import org.icescrum.core.domain.Sprint
import org.icescrum.core.domain.Story
import org.icescrum.core.domain.Task
import org.icescrum.core.domain.User

class ImportXMLServiceTests extends GrailsUnitTestCase {
  ImportXMLService importXMLService
  
  protected void setUp() {
    super.setUp()
    importXMLService = new ImportXMLService()
    mockDomain(Story)
    mockDomain(User)
    mockDomain(Task)
    mockDomain(RemainingEstimationArray)
    mockDomain(Test)
    mockDomain(ExecTest)
    mockDomain(Product)
    mockDomain(Feature)
    mockDomain(Impediment)
    mockDomain(Cliche)
    mockDomain(Release)
    mockDomain(Sprint)
    mockDomain(SprintMeasure)
    mockDomain(Actor)
    mockDomain(Build)
  }

  void testParseTask() {
     def state = Task.STATE_BUSY
    // The XML code to parse and convert to actual instance
    def xmlContent = """<task id="1">
      <taskLabel>A certain task</taskLabel>
      <taskNotes>Some random notes</taskNotes>
      <taskState>$state</taskState>
      <taskCreator>1</taskCreator>
      <taskOwner>1</taskOwner>
    </task>
    """

    // Test data
    def user = new User(id:1, username: "a",
            email: "abdb@mail.com",
            password: "ffvdsbsnbtdfgdfgdfgdfgdfa",
            language: "en")
    def pbi = new Story(name: 'Story0', creator: user, state: Story.STATE_INPROGRESS)
    // The task that should be created by the method
    def expectedTask = new Task(name:'A certain task', notes:'Some random notes', parentStory:pbi, state:state, creator:user, responsible:user)
    importXMLService.usersParsed[user.id] = user

    // Parse the xml code with a slurper and pass it to the method
    def slurper = new XmlSlurper().parseText(xmlContent)
    assertTrue 'The task generated by the service is not the expected one.', expectedTask.equals(importXMLService.parseTask(slurper, pbi))
  }

  void testParseUser() {
    // Define the expected user instance
    def expectedUser = new User(id:1, username: "a",
            email: "abdb@mail.com",
            firstName:"arsene",
            lastName:"lupin",
            password: "ffvdsbsnbtdfgdfgdfgdfgdfa",
            language: "en")
    def xmlContent = """<user id="1">
      <userFirstName>arsene</userFirstName>
      <userLastName>lupin</userLastName>
      <userLogin>a</userLogin>
      <userPwd>ffvdsbsnbtdfgdfgdfgdfgdfa</userPwd>
      <userLanguage>${expectedUser.language}</userLanguage>
      <userEmail>abdb@mail.com</userEmail>
      <active>true</active>
    </user>
    """

    // Parse the XML code with a slurper and pass it to the method
    def slurper = new XmlSlurper().parseText(xmlContent)
    assertTrue 'The task generated by the service is not the expected one.', expectedUser.equals(importXMLService.parseUser(slurper))
  }

  void testParseTest() {
    def pbi = new Story(name: 'Story0', state: Story.STATE_INPROGRESS)

    // Define the expected Test instance
    def expectedTest = new Test(id:1, parentStory: pbi, name: 'test0', state: Test.STATE_UNTESTED, description:'A certain test')

    def xmlContent = """<test id="1">
      <testName>test0</testName>
      <testState>${Test.STATE_UNTESTED}</testState>
      <testDescription>A certain test</testDescription>
    </test>
    """

    // Parse the XML code with a slurper and pass it to the method
    def slurper = new XmlSlurper().parseText(xmlContent)
    assertTrue 'The test generated by the service is not the expected one.', expectedTest.equals(importXMLService.parseTest(slurper, pbi))
  }

  void testParseTheme() {
    def product = new Product()
    def expected = new Feature(id:1, name:'f', description:'desc', textColor:'#000000', backlog:product)
    def xmlContent = """<theme id="1">
      <themeName>f</themeName>
      <themeDescription>desc</themeDescription>
      <themeColor>#FFFFFF</themeColor>
      <themeTextColor>#000000</themeTextColor>
    </theme>
    """
    
    // Parse the XML code with a slurper and pass it to the method
    def slurper = new XmlSlurper().parseText(xmlContent)
    assertTrue 'The custom role generated by the service is not the expected one.', expected.equals(importXMLService.parseTheme(slurper, product))
  }

  void testParseCustomRole() {
    def product = new Product()
    def expected = new Actor(id:1, name:'cr', description:'desc', satisfactionCriteria:'sc', product:product)
    def xmlContent = """<customRole id="1">
      <customRoleName>cr</customRoleName>
      <customRoleDescription>desc</customRoleDescription>
      <customRoleSatisfactionCriteria>sc</customRoleSatisfactionCriteria>
      <customRoleInstances>${Actor.NUMBER_INSTANCES_INTERVAL_1}</customRoleInstances>
      <customRoleUserFrequency>${Actor.USE_FREQUENCY_WEEK}</customRoleUserFrequency>
      <customRoleExpertnessLevel>${Actor.EXPERTNESS_LEVEL_MEDIUM}</customRoleExpertnessLevel>
    </customRole>
    """

    // Parse the XML code with a slurper and pass it to the method
    def slurper = new XmlSlurper().parseText(xmlContent)
    assertTrue 'The custom role generated by the service is not the expected one.', expected.equals(importXMLService.parseCustomRole(slurper, product))
  }

  void testParseBuild(){
    def product = new Product()
    def date = new Date()
    def expectedBuild = new Build(id:1, name:'#1', backlog:product, state:Test.STATE_TESTED, date:date)
    def xmlContent = """<build id="1">
      <buildName>#1</buildName>
      <buildState>${Test.STATE_TESTED}</buildState>
      <buildDate>${date.time}</buildDate>
    </build>
    """

    // Parse the XML code with a slurper and pass it to the method
    def slurper = new XmlSlurper().parseText(xmlContent)
    assertTrue 'The build generated by the service is not the expected one.', expectedBuild.equals(importXMLService.parseBuild(slurper, product))
  }

  void testParseExecTest() {
    def build = new Build(id:1)
    def test = new Test(id:1)
    def date = new Date()
    def expectedET = new ExecTest(id:1, test:test, build:build, date:date, state:Test.STATE_FAILED)
    importXMLService.buildsParsed[build.id.toInteger()] = build
    importXMLService.testsParsed[test.id.toInteger()] = test
    def xmlContent = """<execTest id="1">
      <etState>${Test.STATE_FAILED}</etState>
      <etDate>${date.time}</etDate>
      <etTest>1</etTest>
      <etBuild>1</etBuild>
    </execTest>
    """

    // Parse the XML code with a slurper and pass it to the method
    def slurper = new XmlSlurper().parseText(xmlContent)
    assertTrue 'The exectest generated by the service is not the expected one.', expectedET.equals(importXMLService.parseExecTest(slurper))
  }

  void testParseCliche() {
    def product = new Product()
    def date = new SimpleDateFormat('yyyy-MM-dd HH:mm:ss').parse((new Date()).format('yyyy-MM-dd HH:mm:ss'))
    // Initialization of the (numerous) attributes
    Cliche expectedCliche = new Cliche(
            id:1,
            datePrise:date,
            backlog:product
    )
    expectedCliche.id = 1

    def xmlContent = """<cliche id="1">
      <clicheDate>${date.format('yyyy-MM-dd HH:mm:ss')}</clicheDate>
      <clicheFonctionalStoryEstimatedVelocity>2</clicheFonctionalStoryEstimatedVelocity>
      <clicheDefectEstimatedVelocity>2</clicheDefectEstimatedVelocity>
      <clicheTechnicalStoryEstimatedVelocity>2</clicheTechnicalStoryEstimatedVelocity>
      <clicheFonctionalStoryBacklogPoints>2</clicheFonctionalStoryBacklogPoints>
      <clicheDefectBacklogPoints>2</clicheDefectBacklogPoints>
      <clicheTechnicalStoryBacklogPoints>2</clicheTechnicalStoryBacklogPoints>
      <clicheFonctionalStoryProductRemainingPoints>2</clicheFonctionalStoryProductRemainingPoints>
      <clicheDefectProductRemainingPoints>2</clicheDefectProductRemainingPoints>
      <clicheTechnicalStoryProductRemainingPoints>2</clicheTechnicalStoryProductRemainingPoints>
      <clicheFonctionalStoryReleaseRemainingPoints>2</clicheFonctionalStoryReleaseRemainingPoints>
      <clicheDefectReleaseRemainingPoints>2</clicheDefectReleaseRemainingPoints>
      <clicheTechnicalStoryReleaseRemainingPoints>2</clicheTechnicalStoryReleaseRemainingPoints>
      <clicheFinishedStories>2</clicheFinishedStories>
      <clicheLockedStories>2</clicheLockedStories>
      <clichePlannedStories>2</clichePlannedStories>
      <clicheEstimatedStories>2</clicheEstimatedStories>
      <clicheValidatedStories>2</clicheValidatedStories>
      <clicheIdentifiedStories>2</clicheIdentifiedStories>
      <clicheWrittenTests>2</clicheWrittenTests>
      <clicheProblems>2</clicheProblems>
      <clicheResource>2</clicheResource>
    </cliche>
    """

    // Parse the XML code with a slurper and pass it to the method
    def slurper = new XmlSlurper().parseText(xmlContent)
    def parsed = importXMLService.parseCliche(slurper, product)
    assertTrue 'The Cliche generated by the service is not the expected one.', expectedCliche.equals(parsed)
    assertEquals 2, parsed.fonctionalStoryEstimatedVelocity
    assertEquals 2, parsed.defectEstimatedVelocity
    assertEquals 2, parsed.technicalStoryEstimatedVelocity
    assertEquals 2, parsed.fonctionalStoryBacklogPoints
    assertEquals 2, parsed.defectBacklogPoints
    assertEquals 2, parsed.technicalStoryBacklogPoints
    assertEquals 2, parsed.fonctionalStoryProductRemainingPoints
    assertEquals 2, parsed.defectProductRemainingPoints
    assertEquals 2, parsed.technicalStoryProductRemainingPoints
    assertEquals 2, parsed.fonctionalStoryReleaseRemainingPoints
    assertEquals 2, parsed.defectReleaseRemainingPoints
    assertEquals 2, parsed.technicalStoryReleaseRemainingPoints
    assertEquals 2, parsed.finishedStories
    assertEquals 2, parsed.lockedStories
    assertEquals 2, parsed.plannedStories
    assertEquals 2, parsed.estimatedStories
    assertEquals 2, parsed.validatedStories
    assertEquals 2, parsed.identifiedStories
    assertEquals 2, parsed.writtenTests
    assertEquals 2, parsed.problems
    assertEquals date, parsed.datePrise
    assertEquals 2, parsed.resource
  }

  void testParseRole() {
    // Test data
    def user = new User(id:1, username: "a",
            email: "abdb@mail.com",
            password: "ffvdsbsnbtdfgdfgdfgdfgdfa",
            language: "en")
    user.save()
    importXMLService.usersParsed[user.id.toInteger()] = user
    
    def product = new Product()
    // Define the expected Test instance

    def xmlContent = """<role id="1">
      <roleName></roleName>
      <roleUser>${user.id.toString()}</roleUser>
    </role>
    """

    // Parse the XML code with a slurper and pass it to the method
    def slurper = new XmlSlurper().parseText(xmlContent)
    assertTrue 'The role generated by the service is not the expected one.', expectedRole.equals(importXMLService.parseRole(slurper, product))
  }

  void testParseSprintMeasure() {
    def sprint = new Sprint()
    def fixedDate = new GregorianCalendar(2010, 4, 6)
    def expectedSPM = new SprintMeasure(theSprint:sprint, nbTasks:2, nbTasksDone:1, day:fixedDate)
    def xmlContent = """<SprintMeasure>
      <SprintMeasure_jour>06:04:2010</SprintMeasure_jour>
      <SprintMeasure_NBTasks>2</SprintMeasure_NBTasks>
      <SprintMeasure_NBTasksDone>1</SprintMeasure_NBTasksDone>
    </SprintMeasure>
    """

    // Parse the XML code with a slurper and pass it to the method
    def slurper = new XmlSlurper().parseText(xmlContent)
    assertTrue 'The SprintMeasure generated by the service is not the expected one.', expectedSPM.equals(importXMLService.parseSprintMeasure(slurper, sprint))
  }
}
