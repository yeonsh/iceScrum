package org.icescrum.core.support

import groovy.util.slurpersupport.NodeChild
import groovy.xml.StreamingMarkupBuilder
import groovy.xml.MarkupBuilder
import java.text.SimpleDateFormat
import org.icescrum.core.domain.preferences.UserPreferences
import org.icescrum.core.domain.Task

class XMLConverterSupport {


  static final int CONVERT_TO_IS215 = 1
  def content = null
  def conversionType = null
  def contentConverted = null
  def converted = false

  XMLConverterSupport(def _content){
    content = _content
    if (content && content.isVersion in ['R2#15.1','R2#15']){
      conversionType = CONVERT_TO_IS215
    }
  }

  def getNeedConversion(){
    return conversionType ? true : false
  }

  def convert(){
    if (conversionType){
      switch (conversionType){
        case CONVERT_TO_IS215:
          contentConverted = new XmlSlurper().parseText(IS215Converter())
          break
      }
      return contentConverted
    }else{
      throw new RuntimeException('Conversion type not found')
    }
  }

  def IS215Converter() {
    def writer = new StringWriter()
    def xml = new MarkupBuilder(writer)
    def userPref = new UserPreferences()
    def formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    xml.product() {
      name(content.productName.text())
      pkey(content.productName.text().replaceAll("[/W]", "").replaceAll(" ", "").toUpperCase())
      planningPokerGameType(content.productPlanningPoker.text())
      description(''){
        writer.write("<![CDATA[${content.productDescription}]]>")
      }

      startDate(formatter.format(new SimpleDateFormat('yyyy-MM-dd').parse(content.productStartDate.text())))
      endDate(formatter.format(new Date()))
      preferences(){
        newTeams(false)
        lockPo(false)
        hidden(content.productIsHidden.text().toBoolean()?:false)
        noEstimation(false)
        autoDoneStory(content.productEnableAutoCloseStory.text().toBoolean()?:false)
        displayRecurrentTasks(true)
        displayUrgentTasks(true)
        assignOnCreateTask(false)
        assignOnBeginTask(true)
        autoCreateTaskOnEmptyStory(false)
        limitUrgentTasks(0)
        estimatedSprintsDuration(14)
      }
      teams(){
        team(id:1){
          name(content.productName.text()+' team')
          velocity(0)
          dateCreated(formatter.format(new SimpleDateFormat('yyyy-MM-dd').parse(content.productStartDate.text())))
          description()
          preferences(){
            allowNewMembers(true)
            allowRoleChange(content.productEnableRole.text().toBoolean()?:true)
          }
          def foundSm = null
          scrumMasters(){
            content.role.findAll{ it.roleName.text() == '1' }.each{
              if (it.roleUser.text()?.toInteger()){
                foundSm = -1
                scrumMaster(id:it.roleUser)
              }
            }
            if (foundSm == null){
              content.role.find{ it.roleName.text() == '2' }.each {
                foundSm = it.roleUser.text()
                scrumMaster(id:it.roleUser)
              }
            }
          }
          members(){
            if (foundSm != -1){
              def u = content.user.find{user -> user.@id == foundSm}
              user(id:u.@id){
                firstName(u.userFirstName.text())
                lastName(u.userLastName.text())
                username(u.userLogin.text())
                password(u.userPwd.text())
                email(u.userEmail.text())
                dateCreated(formatter.format(new Date()))
                enabled(true)
                accountExpired(false)
                accountLocked(false)
                passwordExpired(true)
                preferences(){
                  u.userLanguage.text().toInteger() == 0 ? language('fr') : u.userLanguage.text().toInteger() == 1 ? language('en') : language('en')
                  activity()
                  filterTask(userPref.filterTask)
                  menu(userPref.menu)
                  menuHidden(userPref.menuHidden)
                }
                teams(){
                  team(id:1)
                }
              }
            }
            content.role.findAll{ it.roleName.text() != '2' }.each{ role ->
              def u = content.user.find{user -> user.@id == role.roleUser.text()}
              user(id:u.@id){
                firstName(u.userFirstName.text())
                lastName(u.userLastName.text())
                username(u.userLogin.text())
                password(u.userPwd.text())
                email(u.userEmail.text())
                dateCreated(formatter.format(new Date()))
                enabled(true)
                accountExpired(false)
                accountLocked(false)
                passwordExpired(true)
                preferences(){
                  u.userLanguage.text().toInteger() == 0 ? language('fr') : u.userLanguage.text().toInteger() == 1 ? language('en') : language('en')
                  activity()
                  filterTask(userPref.filterTask)
                  menu(''){
                    writer.write(userPref.menu.toMapString())
                  }
                  menuHidden(''){
                    writer.write(userPref.menuHidden.toMapString())
                  }
                }
                teams(){
                  team(id:1)
                }
              }
            }
          }

        }
      }
      releases(){
        content.release.eachWithIndex{ r,ind1 ->
          release(id:r.@id){
            name(r.releaseName.text())
            state(r.releaseState.text())
            releaseVelocity(r.releaseVelocity.text())
            startDate(r.releaseStartDate.text())
            endDate(r.releasePublishDate.text())
            orderNumber(ind1+1)
            vision(''){
              writer.write("<![CDATA[${r.releaseVision.text().replaceAll("<(.|\n)*?>", '').decodeHTML()}]]>")
            }
            description()
            goal(''){
              writer.write("<![CDATA[${r.releaseGoal.text().replaceAll("<(.|\n)*?>", '').decodeHTML()}]]>")
            }
            sprints(){
              r.sprint.eachWithIndex {s,ind2 ->
                sprint(id:s.@id){
                  state(s.sprintState.text())
                  dailyWorkTime(s.sprintDailyWorkTime.text())
                  velocity(s.sprintVelocity.text())
                  capacity(s.sprintEstimatedVelocity.text())
                  resource()
                  endDate(s.sprintEndDate.text())
                  startDate(s.sprintStartDate.text())
                  orderNumber(s.sprintNumber.text())
                  retrospective(''){
                    writer.write("<![CDATA[${s.sprintRetrospective.text().replaceAll("<(.|\n)*?>", '').decodeHTML()}]]>")
                  }
                  doneDefinition(''){
                    writer.write("<![CDATA[${s.sprintFinishDefinition.text().replaceAll("<(.|\n)*?>", '').decodeHTML()}]]>")
                  }
                  goal(''){
                    writer.write("<![CDATA[${r.sprintGoal.text().replaceAll("<(.|\n)*?>", '').decodeHTML()}]]>")
                  }
                  tasks(){
                    def sprintStory = s.story.find{it.storyEstimatedPoints == '-999'}
                    sprintStory.task.eachWithIndex{ t,ind3 ->
                      task(id:t.@id){
                        def estim = null
                        def inProgressD = null
                        def doneD = null
                        if (t.taskRemainingTime.text() != ''){
                          def remainingArray = t.taskRemainingTime.text().split(':')
                          if (remainingArray){
                            def aRemaining = remainingArray[0].split('-')
                            if (aRemaining && aRemaining[1] && aRemaining[1].toInteger() != 99){
                              inProgressD = formatter.format(new SimpleDateFormat('yyyyMMdd').parse(aRemaining[0])).toString()
                            }
                            aRemaining = remainingArray[remainingArray.size() - 1].split('-')
                            if (aRemaining && inProgressD){
                              estim = aRemaining[1].toInteger()
                              if (estim == 0){
                                doneD = formatter.format(new SimpleDateFormat('yyyyMMdd').parse(aRemaining[0])).toString()
                              }else if(estim == 99){
                                estim = null
                              }
                            }
                          }
                        }
                        name(t.taskLabel.text())
                        estim >=0 ? estimation(estim) : estimation()
                        type(Task.TYPE_URGENT)
                        state(t.taskState.text())
                        rank(ind3+1)
                        creationDate(sprintStory.storyCreationDate.text())
                        (inProgressD && t.taskState.text().toInteger() >= 1) ? inProgressDate(inProgressD) : inProgressDate()
                        (doneD && t.taskState.text().toInteger() == 2) ? doneDate(doneD) : doneDate()
                        creator(id:t.taskCreator.text())
                        responsible(id:t.taskOwner.text())
                        description()
                        notes(''){
                          writer.write("<![CDATA[${t.taskNotes.text().replaceAll("<(.|\n)*?>", '').decodeHTML()}]]>")
                        }
                      }
                    }
                  }
                  stories(){
                    s.story.findAll{it.storyEstimatedPoints != '-999'}.eachWithIndex{ st,ind3 ->
                      story(id:st.@id){
                        name(st.storyLabel.text())
                        st.storyState.text().toInteger() == 6 ? state(7) : state(st.storyState.text())
                        suggestedDate(st.storyCreationDate.text())
                        acceptedDate(st.storyCreationDate.text())
                        estimatedDate(st.storyEstimationDate.text())
                        plannedDate(st.storyEstimationDate.text())
                        st.storyState.text().toInteger() >= 5 ? inProgressDate(s.sprintActivationDate.text()) : inProgressDate()

                        def doneD = s.sprintState.text() == 3 ? s.sprintEndDate.text() : s.sprintActivationDate.text()
                        st.storyState.text().toInteger() == 7 ? doneDate(doneD) : doneDate()

                        effort(st.storyEstimatedPoints.text())
                        value(0)
                        rank(ind3+1)
                        creationDate(st.storyCreationDate.text())
                        type(st.storyType.text())
                        executionFrequency(1)
                        description(''){
                          writer.write("<![CDATA[${st.storyDescription.text()}]]>");
                        }
                        notes(''){
                          def notes = st.storyNotes.text().replaceAll("<(.|\n)*?>", '').decodeHTML()
                          st.test.each { test ->
                            notes += "---------Test - ${test.testName.text()}---------- <br>"
                            notes += "${test.testDescription.text()}<br><br>"
                          }
                          writer.write("<![CDATA[${notes}]]>");
                        }
                        (st.storyTheme.text() != '') ? feature(id:st.storyTheme.text()) : feature()
                        (st.storyCustomRole.text() != '') ? actor(id:st.storyCustomRole.text()) : actor()
                        creator(id:st.storyOwner.text())
                        origin('iceScrum '+content.isVersion)
                        tasks(){
                          st.task.eachWithIndex{ t,ind4 ->
                            task(id:t.@id){
                              def estim = null
                              def inProgressD = null
                              def doneDst = null
                              if (t.taskRemainingTime.text() != ''){
                                def remainingArray = t.taskRemainingTime.text().split(':')
                                if (remainingArray){
                                  def aRemaining = remainingArray[0].split('-')
                                  if (aRemaining && aRemaining[1] && aRemaining[1].toInteger() != 99){
                                    inProgressD = formatter.format(new SimpleDateFormat('yyyyMMdd').parse(aRemaining[0])).toString()
                                  }
                                  aRemaining = remainingArray[remainingArray.size() - 1].split('-')
                                  if (aRemaining && inProgressD){
                                    estim = aRemaining[1].toInteger()
                                    if (estim == 0){
                                      doneDst = formatter.format(new SimpleDateFormat('yyyyMMdd').parse(aRemaining[0])).toString()
                                    }else if(estim == 99){
                                      estim  = null
                                    }
                                  }
                                }
                              }
                              name(t.taskLabel.text())
                              estim >= 0 ? estimation(estim) : estimation()
                              type()
                              state(t.taskState.text())
                              rank(ind4+1)
                              (s.sprintActivationDate.text() != "")  ? creationDate(s.sprintActivationDate.text()) : creationDate(s.sprintStartDate.text())
                              (inProgressD && t.taskState.text().toInteger() >= 1)  ? inProgressDate(inProgressD) : inProgressDate()
                              (doneDst && t.taskState.text().toInteger() == 2) ? doneDate(doneDst) : doneDate()
                              creator(id:t.taskCreator.text())
                              responsible(id:t.taskOwner.text())
                              description()
                              notes(''){
                                writer.write("<![CDATA[${t.taskNotes.text().replaceAll("<(.|\n)*?>", '').decodeHTML()}]]>")
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      actors(){
        content.customRole.eachWithIndex { act,ind ->
          actor(id:act.@id){
            name(act.customRoleName.text())
            instances(act.customRoleInstances.text())
            expertnessLevel(act.customRoleExpertnessLevel.text())
            useFrequency(act.customRoleUserFrequency.text())
            creationDate(formatter.format(new Date()))
            satisfactionCriteria(''){
              writer.write("<![CDATA[${act.customRoleSatisfactionCriteria.text()}]]>");
            }
            description(''){
              writer.write("<![CDATA[${act.themeDescription.text()}]]>");
            }
            notes('')
          }
        }
      }
      features(){
        def colors = ['blue','green','red','orange','violet','gray','pink','bluelight']
        content.theme.eachWithIndex { ft,ind ->
          feature(id:ft.@id){
            name(ft.themeName.text())
            Random rand = new Random()
            color(colors[rand.nextInt(7)])
            value(0)
            type(0)
            rank(ind+1)
            creationDate(formatter.format(new Date()))
            description(''){
              writer.write("<![CDATA[${ft.themeDescription.text()}]]>");
            }
            notes('')
          }
        }
      }
      stories(){
        content.story.eachWithIndex { st,ind ->
          story(id:st.@id){
            name(st.storyLabel.text())
            st.storyState.text().toInteger() == 6 ? state(7) : state(st.storyState.text())
            suggestedDate(st.storyCreationDate.text())
            st.storyState.text().toInteger() >= 2 ? acceptedDate(formatter.format(new Date())) : acceptedDate()
            st.storyState.text().toInteger() >= 3 ? estimatedDate(formatter.format(new Date())) : estimatedDate()
            st.storyEstimatedPoints.text() == '-5' ? effort() : effort(st.storyEstimatedPoints.text())
            value(0)
            rank(ind+1)
            creationDate(st.storyCreationDate.text())
            type(st.storyType.text())
            executionFrequency(1)
            description(''){
              writer.write("<![CDATA[${st.storyDescription.text()}]]>");
            }
            notes(''){
              def notes = st.storyNotes.text().replaceAll("<(.|\n)*?>", '').decodeHTML()
              st.test.each { test ->
                notes += "\n \n ---------${test.testName.text()}---------- \n"
                notes += "${test.testDescription.text()}\n\n"
              }
              writer.write("<![CDATA[${notes}]]>")
            }
            (st.storyTheme.text() != '') ? feature(id:st.storyTheme.text()) : feature()
            (st.storyCustomRole.text() != '') ? actor(id:st.storyCustomRole.text()) : actor()
            creator(id:st.storyOwner.text())
            origin('iceScrum '+content.isVersion)
          }
        }
      }
      productOwners(){
        content.role.findAll{ it.roleName.text() == '2' }.each{ role ->
          def u = content.user.find{user -> user.@id == role.roleUser.text()}
          user(id:u.@id){
            firstName(u.userFirstName.text())
            lastName(u.userLastName.text())
            username(u.userLogin.text())
            password(u.userPwd.text())
            email(u.userEmail.text())
            dateCreated(formatter.format(new Date()))
            enabled(true)
            accountExpired(false)
            accountLocked(false)
            passwordExpired(true)
            preferences(){
              u.userLanguage.text().toInteger() == 0 ? language('fr') : u.userLanguage.text().toInteger() == 1 ? language('en') : language('en')
              activity()
              filterTask(userPref.filterTask)
              menu(userPref.menu)
              menuHidden(userPref.menuHidden)
            }
            teams(){
              team(id:1)
            }
          }
        }
      }
    }
    return writer.toString()
  }
}
