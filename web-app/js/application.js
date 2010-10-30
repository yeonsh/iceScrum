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

////Global variables for IS
//
//function jqGridGenerator(table, schema) {
//    $(document).ready(function() {
//        $("#" + table).jqGrid({
//            url:schema.url,
//            datatype: schema.datatype,
//            mtype: schema.mtype,
//            colNames:schema.columns,
//            colModel :schema.colModel,
//            /*pager: '#' + schema.pager,*/
//            rowNum: schema.rowNum,
//            rowList: schema.rowList,
//            sortname: schema.sortName,
//            sortorder: schema.sortOrder ? schema.sortOrder : 'asc',
//            viewrecords: schema.sortOrder,
//            caption: schema.caption,
//            autowidth:true,
//            height:'auto',
//            scrollOffset:0
//        });
//
//        $(window).bind('resize', function() {
//            $("#" + table).setGridWidth($("#gbox_" + table).parent().width() - 2);
//        }).trigger('resize');
//
//    });
//}
//
//function staticGridOptions(id,container){
//    $(window).bind('resize', function() { $("#"+id).setGridWidth($("#gbox_"+id).parent().width() - 5); }).trigger('resize');
//    $($(container)).bind('afterWindowMaximize', function() {$("#"+id).setGridWidth($("#gbox_"+id).parent().width() - 5); });
//}
//
//
//
//gridSelectRow.lastSel = null;
//function gridSelectRow(tableSelector, onComplete) {
//    var tableSelector = tableSelector;
//    var onComplete = onComplete;
//    return function(id) {
//        if (id && id !== gridSelectRow.lastSel) {
//            $(tableSelector).jqGrid('restoreRow', gridSelectRow.lastSel);
//            gridSelectRow.lastSel = id;
//        }
//        $(tableSelector).jqGrid(
//                'editRow',
//                id,
//                true,
//                '', '', '', '',
//                function(postdata, response) {
//                    onComplete(response);
//                },
//                function(postdata, response) {
//                    onComplete(response);
//                }
//                );
//    }
//}