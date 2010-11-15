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
 *
 * Authors:
 *
 * Damien Vitrac (damien@oocube.com)
 *
 */

(function($) {

    var helper = {};

	$.table = {
		defaults: {
            'classNameFocus' : 'table-row-focus'
		}
	};

	$.fn.extend({
		table: function(settings) {
			settings = $.extend({}, $.table.defaults, settings);
            $('.table-cell-checkbox', $(this)).each(function(){

                var elt = $(this);
                var row = elt.parent();
                var input = $('input', elt);
                var td = $('td', row);

                td.click(function(){
                    input.attr('checked', !input.attr('checked'));
                    if (input.attr('checked'))
                    {
                        row.addClass(settings.classNameFocus);
                    }
                    else
                    {
                        row.removeClass(settings.classNameFocus);
                    }
                });
                
                input.change(function(){
                    if ($(this).attr('checked'))
                    {
                        row.addClass(settings.classNameFocus);
                    }
                    else
                    {
                        row.removeClass(settings.classNameFocus);
                    }
                });
            });

            $('th.table-cell-checkbox input').click(function(){
                if($(this).is(':checked')){
                    $(this).parent().parent().parent().parent().parent().find('td.table-cell-checkbox input').attr('checked','checked');
                }else{
                    $(this).parent().parent().parent().parent().parent().find('td.table-cell-checkbox input').removeAttr('checked');
                }
            });
			return this;
		}
	});

})(jQuery);
