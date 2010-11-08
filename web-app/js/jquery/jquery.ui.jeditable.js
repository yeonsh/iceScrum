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

jQuery.editable.addInputType('datepicker', {
    element: function(settings, original) {

        var input = jQuery('<input size=8 />');

        // Catch the blur event on month change
        settings.onblur = function(e) {
        };

        input.datepicker({
            dateFormat: 'yy-mm-dd',
            onSelect: function(dateText, inst) {
                jQuery(this).parents("form").submit();
            },
            onClose: function(dateText, inst) {
                jQuery(this).parents("form").submit();
            }

        });

        input.datepicker('option', 'showAnim', 'slide');

        jQuery(this).append(input);
        return (input);
    }
});


$.editable.addInputType('richarea', {
    element : $.editable.types.textarea.element,
    plugin  : function(settings, original) {
        $('textarea', this).markItUp(settings.markitup);
    }
});


$.editable.addInputType('selectui', {
       element : function(settings, original) {
            var select = $('<select />');
            $(this).append(select);
            return(select);
        },
        content : function(data, settings, original) {
            /* If it is string assume it is json. */
            if (String == data.constructor) {
                eval ('var json = ' + data);
            } else {
            /* Otherwise assume it is a hash already. */
                var json = data;
            }
            for (var key in json) {
                if (!json.hasOwnProperty(key)) {
                    continue;
                }
                if ('selected' == key) {
                    continue;
                }
                var option = $('<option />').val(key).append(json[key]);
                $('select', this).append(option);
            }
            /* Loop option again to set selected. IE needed this... */
            $('select', this).children().each(function() {
                if ($(this).val() == json['selected'] ||
                    $(this).text() == $.trim(original.revert)) {
                        $(this).attr('selected', 'selected');
                }
            }
            );
        },
        plugin: function(settings, original){
            $('select', this).selectmenu({style:"dropdown",maxHeight:200, transferClasses:true});
            $('select', this).bind('close',function(){jQuery(this).parents("form").submit();});
            $('select', this).selectmenu('open');
        }
});
