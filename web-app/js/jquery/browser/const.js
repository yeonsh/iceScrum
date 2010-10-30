
(function($) {
    $.constbrowser = {

        defaults:{
            'dropmenuleft': 0
        },
        settings:{},

        getDropMenuTopLeft:function() {
            var o = $.constbrowser.getConstBrowser();
            return o.dropmenuleft;
        },

        getConstBrowser:function() {
            var o = $.constbrowser.defaults;
            if ($.browser.msie)
            {
                if (jQuery.browser.version.substr(0,1)=="7")
                {
                    o = $.constbrowser.ie7;
                }
                else if (jQuery.browser.version.substr(0,1)=="6")
                {
                    o = $.constbrowser.ie6;
                }

            }
            return o;
        }
    };

    $.constbrowser.ie7 = {
        'dropmenuleft': 70
    };

    $.constbrowser.ie6 = {
        'dropmenuleft': 70
    };

})(jQuery);



