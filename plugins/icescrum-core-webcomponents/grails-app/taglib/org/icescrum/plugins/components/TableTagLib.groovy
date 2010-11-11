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

package org.icescrum.plugins.components

class TableTagLib {
  static namespace = 'is'

  def releaseView = {attrs, body ->
    out << "<div class=\"view-release\">"
    out << body()
    out << "</div>"
  }
  
  def tableView = {attrs, body ->
    out << "<div class=\"view-table\">"
    out << body()
    out << "</div>"
  }

  def table = {attrs, body ->
    pageScope.rowHeaders = []
    pageScope.tableRows = []
    body()

    out << '<table  cellspacing=\"0\" cellmargin=\"0\" border=\"0\" ' + (attrs.id ? "id=\"${attrs.id}\" " : '') + 'class="table '+(attrs."class"?:'')+'">'
    // Header
    out << "<thead>"
    out << '<tr class="table-legend">'
    def maxCols = pageScope.rowHeaders.size()
    pageScope.rowHeaders.eachWithIndex { col, index ->
      col."class" = col."class" ?: ""
      if (index == 0)
        out << '<th '+(col.width?' style=\'width:'+col.width+'\'':'') +' class="' + col."class" + ' first"><div class=\"table-cell\">' << is.nbps(null, col.name) << '</div></th>'
      else if (index == (maxCols - 1))
        out << '<th '+(col.width?' style=\'width:'+col.width+'\'':'') +' class="' + col."class" + ' last"><div class=\"table-cell\">' << is.nbps(null, col.name) << '</div></th>'
      else
        out << '<th '+(col.width?' style=\'width:'+col.width+'\'':'') +' class="' + col."class" + '"><div class=\"table-cell\">' << is.nbps(null, col.name) << '</div></th>'
    }
    out << '</tr>'
    out << "</thead>"

    // Rows
    def maxRows = pageScope.tableRows?.size() ?: 0

    //edtitable type in columns
    def editables = [:]

    out << "<tbody>"
    pageScope.tableRows.eachWithIndex { row, indexRow ->
      def elemID = ''
      if(row.attrs.elemID)
        elemID = row?.attrs?."${row.attrs.var}"?."${row.attrs.elemID}"?:''

      def version
      if (!row.attrs.version)
        row.attrs.version = 0
      if (row?.attrs?."${row.attrs.var}"?.version == 0){
        version = 0
      }else if(row?.attrs?."${row.attrs.var}"?.version == null){
        version = 0
      }else {
        version = row?.attrs?."${row.attrs.var}"?.version
      }
      if (indexRow == (maxRows - 1))
        out << '<tr class="table-line line-last" elemID="'+elemID+'" version="'+version+'">'
      else
        out << '<tr class="table-line"  elemID="'+elemID+'" version="'+version+'">'
      row.columns.eachWithIndex { col, indexCol ->

        //gestion editable
        def editable = col.editable?.name?:col.editable?.type?:null
        if(editable && !editables."${editable}"){
          editables."${editable}" = [id:col.editable.id?:'',type:col.editable.type,values:col.editable.values?:null,detach:col.editable.detach?:false]  
        }

        col."class" = col."class" ?: ""
        if (indexCol == 0)
          out << '<td class="' + col."class" + ' break-word first"><div '+is.editableCell(col.editable)+'>' + is.nbps(null, col?.body(row.attrs)) + '</div></td>'
        else if (indexCol == (maxCols - 1))
          out << '<td class="' + col."class" + ' break-word last"><div '+is.editableCell(col.editable)+'>' + is.nbps(null, col?.body(row.attrs)) + '</div></td>'
        else
          out << '<td class="' + col."class" + ' break-word"><div '+is.editableCell(col.editable)+'>' + is.nbps(null, col?.body(row.attrs)) + '</div></td>'
      }
      out << '</tr>'
    }
    // end
    out << "<tbody>"
    out << '</table>'
    
    def jqCode = "\$('#${attrs.id}').table()"
    if (attrs.editable){
      attrs.editable.var = pageScope.tableRows?.attrs?.var[0]?:''
      editables?.each{k,v->
        attrs.editable.type = v.type
        attrs.editable.id = v.id
        attrs.editable.values = v.values
        attrs.editable.detach = v.detach
        jqCode = jqCode + is.jeditable(attrs.editable)
        attrs.editable.remove('type')
        attrs.editable.remove('values')
        attrs.editable.remove('id')
      }
    }
    out << jq.jquery(null,jqCode)
  }

  def nbps = {attrs, body ->
    def a = body().trim()
    if (a) {
      out << body()
    }
    else {
      out << """&nbsp;"""
    }
  }

  def editableCell = {attrs ->
    if (attrs?.type && attrs?.name && !attrs?.disabled)
      out << 'class="table-cell table-cell-editable table-cell-editable-'+attrs.type+(attrs.id?'-'+attrs.id:'')+'" name="'+attrs.name+'"'
    else
      out << 'class="table-cell"'
  }  

  def jeditable = {attrs ->
    def jqCode = ""
    def finder = ""
    def data = ""
    def detach = "'${attrs.var}.'+\$(this).attr('name')"

    if (attrs.detach){
      detach = "\$(this).attr('name')"
    }


    if (attrs.type == 'text'){
      finder = "\$(original).find('input').val()"
      data ="return jQuery.icescrum.htmlDecode(value);"
    }
    else if (attrs.type == 'textarea'){
      finder = "\$(original).find('textarea').val()"
      data ="return jQuery.icescrum.htmlDecode(value);"
    }
    else if (attrs.type == 'datepicker'){
      finder = "\$(original).find('textarea').val()"
      data ="return jQuery.icescrum.htmlDecode(value);"
    }
    else if (attrs.type == 'richarea'){
      finder = "\$(original).find('textarea').val()"
      data ="return jQuery.icescrum.htmlDecode(value);"
    }
    else if (attrs.type == 'selectui'){
      finder = "\$(original).find('select').children('option:selected').text()"
      data = "return {${attrs.values},'selected':value};"
    }
    jqCode = """
                \$('.table-cell-editable-${attrs.type}${attrs.id?'-'+attrs.id:''}').editable('${createLink(action:attrs.action,controller:attrs.controller,params:attrs.params)}',{
                    type:'${attrs.type}',
                    data : function(value, settings) {settings.name = ${detach}; settings.id = '${attrs.var}.id';${data}},
                    onsubmit:function(settings, original){if (${finder} == original.revert) { original.reset(); return false;}},
                    submitdata : function(value, settings) {return {'name':\$(this).attr('name'),'table':true,'${attrs.var}.id':\$(this).parent().parent().attr('elemID'),'${attrs.var}.version':\$(this).parent().parent().attr('version')};},
                    callback:function(value, settings) {var version = \$(this).parent().parent().attr('version'); \$(this).parent().parent().attr('version',parseInt(version)+1); return jQuery.icescrum.htmlDecode(value);},
                    onblur:'${attrs.onExitCell}'
                    ${attrs.type == 'richarea' ?", loaddata:function(revert, settings){settings.name = ${detach}; settings.id = '${attrs.var}.id'; return {'${attrs.var}.id':\$(this).parent().parent().attr('elemID')}},loadurl : '"+createLink(action:attrs.action,controller:attrs.controller,params:attrs.params)+"?loadrich=true',markitup : textileSettings":""}
                });
             """
    out << jqCode
  }

  /**
   * Helper tag for a Table header
   */
  def tableHeader = { attrs, body ->
    if (pageScope.rowHeaders == null) return

    def options = [
            name: attrs.name,
            key: attrs.key,
            width:attrs.width?:null,
            'class': attrs."class"
    ]

    pageScope.rowHeaders << options
  }

  /**
   * Helper tag for the Table rows
   */
  def tableRows = { attrs, body ->
    attrs.'in'.eachWithIndex { row, indexRow ->
      def attrsCloned = attrs.clone()
      attrsCloned[attrs.var] = row
      pageScope.tableColumns = []
      body(attrsCloned)
      def columns = pageScope.tableColumns.clone()
      attrsCloned.remove('in')
      def options = [
              columns:columns,
              attrs:attrsCloned
      ]

      pageScope.tableRows << options
    }

  }

  /**
   * Helper tag for a specific Table row
   */
  def tableRow = { attrs, body ->
    pageScope.tableColumns = []
    body()
    def options = [
            columns:pageScope.tableColumns,
            attrs:attrs
    ]
    pageScope.tableRows << options
  }

  /**
   * Helper tag for the column content
   */
  def tableColumn = { attrs, body ->
    if (pageScope.tableColumns == null) return

    def options = [
            key: attrs.key,
            editable:attrs.editable?:null,
            'class': attrs.'class',
            groupUid:'group-' + (new Date().time),
            body: body ?: {->}
    ]

    pageScope.tableColumns << options
  }
}
