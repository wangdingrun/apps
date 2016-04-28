Template.loginLayout.helpers
                
        urlPrefix: ->
                return __meteor_runtime_config__.ROOT_URL_PATH_PREFIX
                

Template.loginLayout.onCreated ->
        self = this;

        $(window).resize ->
                $(".content-wrapper").height($(window).height() - 50);


Template.loginLayout.onRendered ->

        $(window).resize();

        if ($("body").hasClass('sidebar-open')) 
                $("body").removeClass('sidebar-open');
