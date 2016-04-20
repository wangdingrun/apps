Template.workflow_main.helpers 

	instanceId: ->
		return Session.get("instanceId")


Template.workflow_main.onCreated ->

        $(window).resize ->
                $(".wrapper").height($(window).height())

                $(".instance-list-wrapper").height($(window).height()-50);
                $(".instance-wrapper").height($(window).height()-50);

                instanceWidth = $(window).width() - $(".main-sidebar").width() - $(".instance-list-wrapper").width() - 1
                $(".instance-wrapper").width(instanceWidth)

Template.workflow_main.onRendered ->

	$(window).resize();


