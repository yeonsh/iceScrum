import grails.util.GrailsNameUtils
import grails.plugin.attachmentable.Attachment
import org.apache.commons.io.FilenameUtils
import grails.plugin.attachmentable.AttachmentLink
import grails.plugin.attachmentable.AttachmentException
import grails.plugin.attachmentable.Attachmentable
import javax.activation.MimetypesFileTypeMap
import grails.plugin.attachmentable.AttachmentableService

class AttachmentableGrailsPlugin {
    // the plugin version
    def version = "0.1"
    // the version or versions of Grails the plugin is designed for
    def grailsVersion = "1.3 > *"
    // the other plugins this plugin depends on
    def dependsOn = [:]
    // resources that are excluded from plugin packaging
    def pluginExcludes = [
            "grails-app/views/error.gsp"
    ]

    // TODO Fill in these fields
    def author = "Vincent Barrier"
    def authorEmail = "vincent.barrier@icescrum.com"
    def title = "iceScrum attachmentable plugin"
    def description = '''Attach file to your domain class in a generic manner (without MultipartFile or Ajax)
           if you don't need to customize ajax/multipartFile -> Try Attachmentable plugin'''

    // URL to the plugin's documentation
    def documentation = "http://grails.org/plugin/attachmentable"

    def doWithSpring = {
        attachmentsBaseDir application
    }

    def doWithDynamicMethods = { ctx ->
        AttachmentableService service = ctx.getBean('attachmentableService')

        for (domainClass in application.domainClasses) {
        if (Attachmentable.class.isAssignableFrom(domainClass.clazz)) {
          domainClass.clazz.metaClass {

            addAttachment{ poster,File file, String originalName = null ->
              service.addAttachment(poster, delegate, file, originalName)
            }

            /*addAttachments{ poster, List<File> files ->
              files.each { file ->
                addAttachment(poster, file)
              }
            }*/

            addAttachments{ poster, def tmpFiles ->
              tmpFiles.each { tmpFile ->
                if (tmpFile instanceof File)
                  addAttachment(poster, tmpFile)
                addAttachment(poster, tmpFile.file, tmpFile.name)
              }
            }

            removeAttachment { Attachment a ->
              service.removeAttachment(a,delegate)
              AttachmentLink.findAllByAttachment(a)*.delete()
              a.delete(flush:true)
            }

            removeAttachment { Long id ->
              def a = Attachment.load(id)
              if (a) removeAttachment(a)
            }

            removeAllAttachments {
              def delDir = delegate.attachments.size() > 0 ?: false
              delegate.attachments?.each{ Attachment a ->
                 removeAttachment(a)
              }
              if (delDir)
                service.removeAttachmentDir(delegate)
            }

            getAttachments = {->
              AttachmentLink.getAttachments(delegate).list()
            }

            getTotalAttachments = {->
              AttachmentLink.getTotalAttachments(delegate).list()[0]
            }
          }
        }
      }
    }

    private void attachmentsBaseDir(application) {
        def dir = application.config.grails.attachmentable?.baseDir
        if (!dir) {
            String userHome  = System.properties.'user.home'
            String appName   = application.metadata['app.name']
            dir = new File(userHome, appName).canonicalPath
            application.config.grails.attachmentable.baseDir = dir
        }
    }
}
