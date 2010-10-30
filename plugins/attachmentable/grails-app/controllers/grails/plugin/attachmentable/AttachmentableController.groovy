package grails.plugin.attachmentable

import grails.converters.JSON
import javax.servlet.http.HttpServletResponse

class AttachmentableController {

  def attachmentableService

  def download = {
    Attachment attachment = Attachment.get(params.id as Long)
    if (attachment) {
        File file = attachmentableService.getFile(attachment)

        if (file.exists()) {
            String filename = attachment.filename
            ['Content-disposition': "attachment;filename=\"$filename\"",'Cache-Control': 'private','Pragma': ''].each {k, v ->
                response.setHeader(k, v)
            }
            response.contentType = attachment.contentType
            response.outputStream << file.newInputStream()
            return
        }
    }
    response.status = HttpServletResponse.SC_NOT_FOUND
  }
}
