Template.workflow_main.helpers 

	instanceId: ->
		return Session.get("instanceId")


Template.workflow_main.onCreated ->

        $(window).resize ->
        	if Steedos.isMobile()
                $(".wrapper").height($(window).height())

                $(".instance-list-wrapper").height($(window).height()-50);
                $(".instance-wrapper").height($(window).height()-50);

                windowWidth = $(window).width() - 1
                $(".instance-wrapper").width(windowWidth)
                $(".instance-list-wrapper").width(windowWidth)

        	else
                $(".wrapper").height($(window).height())

                $(".instance-list-wrapper").height($(window).height()-50);
                $(".instance-wrapper").height($(window).height()-50);

                $(".instance-list-wrapper").width(350)
                instanceWidth = $(window).width() - $(".main-sidebar").width() - $(".instance-list-wrapper").width() - 1
                $(".instance-wrapper").width(instanceWidth)

Template.workflow_main.onRendered ->

	$(window).resize();


