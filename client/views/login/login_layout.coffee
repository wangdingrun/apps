Template.loginLayout.helpers
                
        urlPrefix: ->
                return __meteor_runtime_config__.ROOT_URL_PATH_PREFIX
                
        isLoggedout: ->
                if Meteor.userId()
                        return false;
                else
                        return true;

Template.loginLayout.onCreated ->
        self = this;

        $(window).resize ->
                $(".content-wrapper").height($(window).height() - 50);


Template.loginLayout.onRendered ->

        $(window).resize();

        if ($("body").hasClass('sidebar-open')) 
                $("body").removeClass('sidebar-open');
