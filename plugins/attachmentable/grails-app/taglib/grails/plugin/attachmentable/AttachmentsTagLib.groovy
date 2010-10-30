package grails.plugin.attachmentable

class AttachmentsTagLib {

	static namespace = "attachments"

	def each =  { attrs, body ->
		def bean = attrs.bean
		def varName = attrs.var ?: "attachment"
		if(bean?.metaClass?.hasProperty(bean, "attachments")) {
			bean.attachments?.each {
				out << body((varName):it)
			}
		}
	}

	def eachRecent = { attrs, body ->
		def domain = attrs.domain
		if(!domain && attrs.bean) domain = attrs.bean?.class
		def varName = attrs.var ?: "attachment"

		if(domain) {
			domain.recentAttachments?.each {
				out << body((varName):it)
			}
		}
	}
}
