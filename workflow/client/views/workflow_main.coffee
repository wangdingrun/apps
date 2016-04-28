Template.workflow_main.helpers 

	instanceId: ->
		return Session.get("instanceId")


Template.workflow_main.onCreated ->

	$(window).resize ->
		if Steedos.isMobile()
			$(".instance-wrapper").css("left", "0px")
			windowWidth = $(window).width() - 1
			$(".instance-list-wrapper").width(windowWidth)

		else
			#$(".wrapper").height($(window).height())

			#$(".instance-list-wrapper").height($(window).height()-50);
			#$(".instance-wrapper").height($(window).height()-50);
			$(".instance-wrapper").css("left", "351px")
			$(".instance-list-wrapper").width(350)
			$(".instance-list-wrapper").show();

Template.workflow_main.onRendered ->

	$(window).resize();


