checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		redirect('/sign-in');


FlowRouter.route '/space/:spaceId', 
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->
		if !Meteor.userId()
			FlowRouter.go '/sign-in';
		Session.set("spaceId", params.spaceId);
		localStorage.setItem("spaceId", params.spaceId);
		FlowRouter.go "/space/" + params.spaceId + "/inbox/"

		# Tracker.autorun (c) ->
		# 	if FlowRouter.subsReady() is true
		# 		Meteor.defer ->
		# 			FlowRouter.go "/space/" + params.spaceId + "/inbox/"
		# 		c.stop()



FlowRouter.route '/space/:spaceId/:box/', 
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->
		if Session.get("spaceId") != params.spaceId 
			Session.set("spaceId", params.spaceId);
		localStorage.setItem("spaceId", params.spaceId);
		Session.set("box", params.box);
		Session.set("flowId", undefined);
		Session.set("instanceId", null); 
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"
		
		$(".instance-wrapper").hide();
		$(".instance-list-wrapper").show();


FlowRouter.route '/space/:spaceId/:box/:instanceId', 
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->

		if Session.get("spaceId") != params.spaceId 
			Session.set("spaceId", params.spaceId);
		localStorage.setItem("spaceId", params.spaceId);
		Session.set("instanceId", null);

		console.log "call get_instance_data"
		$(document.body).addClass "loading";

		BlazeLayout.render 'masterLayout',
			main: "workflow_main"

		if (Steedos.isMobile())
			$(".instance-wrapper").show();
			$(".instance-list-wrapper").hide();
		else
			$(".instance-wrapper").show();
			$(".instance-list-wrapper").show();
			
		WorkflowManager.callInstanceDataMethod params.instanceId, ()->
			console.log "response get_instance_data" 

			Session.set("judge", null);
			Session.set("next_step_id", null);
			Session.set("next_step_multiple", null);
			Session.set("next_user_multiple", null);
			Session.set("instanceId", params.instanceId);
			Session.set("box", params.box);


			$(document.body).removeClass "loading";


	triggersExit: [
		()->
			Session.set("instanceId", null)
	]
