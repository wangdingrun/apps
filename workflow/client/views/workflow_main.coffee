Template.workflow_main.helpers 

	instanceId: ->
		return Session.get("instanceId")


	showInstance: ->
		if !Session.get("instanceId")
			return false;
		return Steedos.subsReady() 


Template.workflow_main.onCreated ->

		# if Steedos.isMobile()
		# 	$(".instance-wrapper").css("left", "0px")
		# 	windowWidth = $(window).width() - 1
		# 	$(".instance-list-wrapper").width(windowWidth);

		# 	if Session.get("instanceId")
		# 		$(".instance-wrapper").show();
		# 		$(".instance-list-wrapper").hide();
		# 	else
		# 		$(".instance-wrapper").hide();
		# 		$(".instance-list-wrapper").show();
		# else
		# 	#$(".instance-wrapper").css("left", "351px")
		# 	#$(".instance-list-wrapper").width(350)



Template.workflow_main.onRendered ->
