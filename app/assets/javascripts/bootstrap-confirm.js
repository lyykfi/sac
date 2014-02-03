(function ($) {
    $.fn.extend({
        //pass the options variable to the function
        confirmModal: function (options) {
            var defaults = {
              heading: 'Please confirm',
              body:'Body contents',
              callback: null,
              okButtonText: 'Удалить',
              cancelButtonText: 'Отмена',
              enableCancel: true,
              enableOk: true
            };

            var html = '<div class="modal" id="confirmContainer"><div class="modal-header"><a class="close" data-dismiss="modal">×</a>' +
            '<h3>#Heading#</h3></div><div class="modal-body">' +
            '#Body#</div><div class="modal-footer">';

            var options = $.extend(defaults, options);

            if (options.enableOk) {
              html += '<a href="#" class="btn btn-primary" id="confirmYesBtn">#okButtonText#</a>';
            }
            if (options.enableCancel) {
              html += '<a href="#" class="btn" data-dismiss="modal">#cancelButtonText#</a></div></div>';
            }

            html = html.replace('#Heading#',options.heading).replace('#Body#',options.body).replace('#okButtonText#',options.okButtonText).replace('#cancelButtonText#',options.cancelButtonText);
            $(this).html(html);
            $(this).modal('show');
            var context = $(this); 
            $('#confirmYesBtn',this).click(function(){
                if(options.callback!=null)
                    options.callback();
                $(context).modal('hide');
            });
        }
    });

})(jQuery);