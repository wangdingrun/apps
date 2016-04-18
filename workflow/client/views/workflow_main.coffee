Template.workflow_main.helpers 

	instanceId: ->
		return Session.get("instanceId")




Template.workflow_main.onCreated ->
        $(window).resize ->
                $(".instance-list-wrapper").height($(window).height()-50);
                $(".instance-wrapper").height($(window).height()-50);

Template.workflow_main.onRendered ->

	$(window).resize();


