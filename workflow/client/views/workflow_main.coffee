Template.workflow_main.helpers 

	instanceId: ->
		return Session.get("instanceId")




Template.workflow_main.onRendered ->

	$(".instance-list-wrapper").height($(window).height()-50);
	$(".instance-wrapper").height($(window).height()-50);


