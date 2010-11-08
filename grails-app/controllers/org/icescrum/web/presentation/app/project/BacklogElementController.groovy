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

package org.icescrum.web.presentation.app.project

import grails.converters.JSON
import grails.plugins.springsecurity.Secured
import grails.util.GrailsNameUtils
import org.grails.comments.Comment
import org.grails.comments.CommentLink
import org.icescrum.core.domain.Product
import org.icescrum.core.domain.Story
import org.icescrum.core.domain.Task
import org.icescrum.core.domain.User
import org.springframework.web.servlet.support.RequestContextUtils

class BacklogElementController {

  static ui = true

  static final id = 'backlogElement'
  static menuBar = [title: 'is.ui.backlogelement', show: {false}]
  static window = [title: 'is.ui.backlogelement', toolbar: true, init: 'details']

  def productBacklogService
  def commentService
  def springSecurityService
  def securityService

  /**
   * Render the toolbar of the window
   */
  def toolbar = {
    if (!params.id) {
      render(text: '')
      return
    }
    def user = null
    if (springSecurityService.isLoggedIn())
      user = User.load(springSecurityService.principal.id)
    def story = Story.get(params.long('id'))
    // Cannot proceed if we don't have a story
    if (!story) {
      render(text: '')
      return
    }

    def next = null
    def previous = null

    switch(story.state){
      case Story.STATE_SUGGESTED:
        next = Story.findNextSuggested(story.backlog.id,story.suggestedDate).list()[0]?:Story.findNextAcceptedOrEstimated(story.backlog.id,1).list()[0]?:null
        previous = Story.findPreviousSuggested(story.backlog.id,story.suggestedDate).list()[0]?:null
        break
      case Story.STATE_ACCEPTED:
      case Story.STATE_ESTIMATED:
        next = Story.findNextAcceptedOrEstimated(story.backlog.id,story.rank + 1).list()[0]?:null
        previous = Story.findNextAcceptedOrEstimated(story.backlog.id,story.rank - 1).list()[0]?:Story.findFirstSuggested(story.backlog.id).list()[0]?:null
        break
      case Story.STATE_PLANNED:
      case Story.STATE_INPROGRESS:
      case Story.STATE_DONE:
        previous = Story.findBySprintAndRank(story.sprint,story.rank-1)?:Story.findLastAcceptedOrEstimated(story.backlog.id).list()[0]?:Story.findFirstSuggested(story.backlog.id).list()[0]?:null
      break
    }

    render(template: 'window/toolbar',model: [id: id, story: story, user: user,next:next,previous:previous])
  }

  /**
   * Display the story's information, activities & comments
   */
  def details = {
    if (!params.id) {
      if (springSecurityService.isAjax(request)) {
        def jqCode = jq.jquery(null, "\$.icescrum.renderNotice('${message(code: 'is.story.error.not.exist')}','error');");
        render(status: 400, text: jqCode);
      }else{
        render(status: 400, contentType: 'application/json', text: [notice: [text: 'is.story.error.not.exist']] as JSON)
      }
      return
    }

    def story = Story.get(params.long('id'))
    if (!story) {
      render(status: 400, contentType: 'application/json', text: [notice: [text: 'is.story.error.not.exist']] as JSON)
      return
    }

    def user = null
    if (springSecurityService.isLoggedIn())
      user = User.load(springSecurityService.principal.id)

    Product product = (Product) story.backlog
    if (product.preferences.hidden && !user) {
      redirect(controller: 'login', params:[ref:"p/${product.pkey}@backlogElement/$story.id"])
      return
    } else if (product.preferences.hidden && !securityService.inProduct(story.backlog.id, springSecurityService.authentication)) {
      render(status: 403)
    } else {
      def activities = story.getActivities()
      // Retrieve the tasks activity links
      if (story.tasks) {
        story.tasks*.getActivities()*.each { activities << it }
      }
      activities = activities.sort { it1, it2 -> it2.dateCreated <=> it1.dateCreated }

      def summary = story.comments + activities
      def permalink = createLink(absolute: true, mapping: "shortURL", params: [product: product.pkey], id: story.id)
      summary = summary.sort { it1, it2 -> it1.dateCreated <=> it2.dateCreated }
      render(view: 'details', model: [
              story: story,
              tasksDone: story.tasks?.findAll {it.state == Task.STATE_DONE}?.size() ?: 0,
              typeCode: ProductBacklogController.typesBundle[story.type],
              storyStateCode: ProductBacklogController.stateBundle[story.state],
              taskStateBundle: SprintBacklogController.taskStateBundle,
              activities: activities,
              comments: story.comments,
              user: user,
              summary: summary,
              pkey: product.pkey,
              permalink: permalink,
              locale: RequestContextUtils.getLocale(request),
              id: id
      ])
    }
  }

  @Secured('isAuthenticated()')
  def addComment = {
    def poster = User.load(springSecurityService.principal.id)
    def commentLink
    try {
      if (params['comment'] instanceof Map) {
        Comment.withTransaction { status ->
          def comment = new Comment(params.comment)
          comment.posterId = poster.id
          comment.posterClass = poster.class.name
          commentLink = new CommentLink(params.commentLink)
          commentLink.type = GrailsNameUtils.getPropertyName(commentLink.type)

          if (!comment.save()) {
            status.setRollbackOnly()
          } else {
            commentLink.comment = comment
            def story = Story.get(commentLink.commentRef)
            story.addActivity(poster, 'comment', story.name)
            if (!commentLink.save()) status.setRollbackOnly()
          }
        }
      }
    } catch (Exception e) {
      log.error "Error posting comment: ${e.message}"
      render(status: 400, contentType: 'application/json', text: [notice: [text: message(code: 'is.ui.backlogelement.comment.error')]] as JSON)
      return
    }

    def comments = CommentLink.withCriteria {
      projections {
        property "comment"
      }
      eq 'type', commentLink.type
      eq 'commentRef', commentLink.commentRef
      cache true
    }
    // Reload the comments
    forward(controller: controllerName, action: 'activitiesPanel', id: params.commentLink.commentRef, params: ['tab': 'comments'])
    pushOthers "${params.product}-backlogElement-${params.commentLink.commentRef}-activities"
  }

  /**
   * Render a editor for the specified comment.
   */
  @Secured('isAuthenticated()')
  def editCommentEditor = {
    if (params.id == null) {
      render(status: 400, contentType: 'application/json', text: [notice: [text: message(code: 'is.ui.backlogelement.comment.error.not.exists')]] as JSON)
      return
    }
    def comment = Comment.get(params.long('id'))
    def story = Story.get(params.long('commentable'))
    render(template: '/components/commentEditor', plugin: 'icescrum-core-webcomponents', model: [comment: comment, mode: 'edit', commentable: story])
  }

  /**
   * Update a comment content
   */
  def editComment = {
    if (params.comment.id == null) {
      render(status: 400, contentType: 'application/json', text: [notice: [text: message(code: 'is.ui.backlogelement.comment.error.not.exists')]] as JSON)
      return
    }
    def comment = Comment.get(params.long('comment.id'))
    comment.body = params.comment.body
    comment.save()
    forward(controller: controllerName, action: 'activitiesPanel', id: params.commentLink.commentRef, params: [product: params.product, 'tab': 'comments'])
    pushOthers "${params.product}-backlogElement-${params.commentLink.commentRef}-activities"
  }

  /**
   * Remove a comment from the comment list of a story
   */
  @Secured('productOwner() or scrumMaster()')
  def deleteComment = {
    if (params.id == null) {
      render(status: 400, contentType: 'application/json', text: [notice: [text: message(code: 'is.ui.backlogelement.comment.error.not.exists')]] as JSON)
      return
    }
    if (params.backlogelement == null) {
      render(status: 400, contentType: 'application/json', text: [notice: [text: message(code: 'is.story.error.not.exist')]] as JSON)
      return
    }
    def comment = Comment.get(params.long('id'))
    def commentable = Story.get(params.long('backlogelement'))

    try {
      commentable.removeComment(comment)
      render include(controller: controllerName, action: 'activitiesPanel', id: params.backlogelement, params: [product: params.product, 'tab': 'comments'])
      pushOthers "${params.product}-backlogElement-${params.backlogelement}-activities"
    } catch (RuntimeException e) {
      render(status: 400, contentType: 'application/json', text: [notice: [text: message(code: e.getMessage())]] as JSON)
    }
  }

  @Secured('productOwner()')
  def accept = {
    if (params.id == null) {
      render(status: 400, contentType: 'application/json', text: [notice: [text: message(code: 'is.ui.sandbox.menu.accept.error.no.selection')]] as JSON)
      return
    }
    def story = Story.get(params.long('id'))
    try {
      // Call the proper service depending of the type of acceptation
      switch (params.int('acceptAs')) {
        case 0:
          productBacklogService.acceptStoryToProductBacklog(story)
          push "${params.product}-productBacklog"
          break
        case 1:
          productBacklogService.acceptStoryToFeature(story)
          push "${params.product}-feature"
          break
        case 2:
          productBacklogService.acceptStoryToUrgentTask(story)
          push "${params.product}-sprintBacklog"
          break
      }

      // If we're accepting as a story, the details is reloaded with the updated data
      if (!(params.int('acceptAs') in [1, 2])) {
        forward(controller: id, action: 'details', id: params.id, params: [product: params.product])
        // If we're accepting as a feature or a task, the GSP will redirect to the sandbox
      } else {
        render(status: 200)
      }

      // Send update notice to the sandbox & the eventual user that were reading the details page 
      pushOthers "${params.product}-sandbox"
      pushOthers "${params.product}-${id}-${params.id}"
    } catch (IllegalStateException e) {
      e.printStackTrace()
      render(status: 400, contentType: 'application/json', text: [notice: [text: message(code: e.getMessage())]] as JSON)
    } catch (RuntimeException e) {
      e.printStackTrace()
      render(status: 400, contentType: 'application/json', text: [notice: [text: message(code: e.getMessage())]] as JSON)
    }
  }

  def shortURL = {
    redirect(url: is.createScrumLink(controller: 'backlogElement', id: params.id))
  }


  def idURL = {

    if (!params.id) {
      if (springSecurityService.isAjax(request)) {
        def jqCode = jq.jquery(null, "\$.icescrum.renderNotice('${message(code: 'is.story.error.not.exist')}','error');");
        render(status: 400, text: jqCode);
      }
      return
    }

    def story = Story.get(params.id)

    if (!story) {
      render(status: 400, contentType: 'application/json', text: [notice: [text: 'is.story.error.not.exist']] as JSON)
      return
    }

    params.product = story.backlog.id

    redirect(url: is.createScrumLink(controller: 'backlogElement', id: params.id))
  }

  /**
   * Content of the activities panel
   */
  def activitiesPanel = {
    if (params.id == null) {
      render(status: 400, contentType: 'application/json', text: [notice: [text: 'is.story.error.not.exist']] as JSON)
      return
    }
    def story = Story.get(params.long('id'))
    if (!story) {
      render(status: 400, contentType: 'application/json', text: [notice: [text: 'is.story.error.not.exist']] as JSON)
      return
    }
    def user = null
    if (springSecurityService.isLoggedIn())
      user = User.load(springSecurityService.principal.id)
    def activities = story.getActivities()
    // Retrieve the tasks activity links
    if (story.tasks) {
      story.tasks*.getActivities()*.each { activities << it }
    }
    activities = activities.sort { it1, it2 -> it2.dateCreated <=> it1.dateCreated }

    def summary = story.comments + activities
    summary = summary.sort { it1, it2 -> it1.dateCreated <=> it2.dateCreated }
    render(template: "window/activities",
            model: [activities: activities,
                    taskStateBundle: SprintBacklogController.taskStateBundle,
                    summary: summary,
                    user: user,
                    comments: story.comments,
                    story: story,
                    id: id,
                    product: params.product
            ])

  }
}
