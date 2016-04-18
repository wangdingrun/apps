Template.loginLayout.onCreated ->
        self = this;

        $(window).resize ->
                $(".content-wrapper").height($(window).height() - 50);


Template.loginLayout.onRendered ->

        $(window).resize();
