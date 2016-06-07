checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		redirect('/sign-in');


FlowRouter.route '/workflow',
	action: (params, queryParams)->
		if Session.get("spaceId")
			FlowRouter.go("/workflow/space/" + Session.get("spaceId") + "/inbox/")
		else
			FlowRouter.go("/workflow/space/")


FlowRouter.route '/workflow/space/:spaceId', 
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->
		if !Meteor.userId()
			FlowRouter.go '/sign-in';
		Session.set("spaceId", params.spaceId);
		localStorage.setItem("spaceId:" + Meteor.userId(), params.spaceId);
		FlowRouter.go "/workflow/space/" + params.spaceId + "/inbox/"


FlowRouter.route '/workflow/space/:spaceId/:box/', 
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->
		if Session.get("spaceId") != params.spaceId 
			Session.set("spaceId", params.spaceId);
		localStorage.setItem("spaceId:" + Meteor.userId(), params.spaceId);
		Session.set("box", params.box);
		Session.set("flowId", undefined);
		#Session.set("instanceId", null); 
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"
		
		$(".workflow-main").removeClass("instance-show")


FlowRouter.route '/workflow/space/:spaceId/:box/:instanceId', 
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->

		if Session.get("spaceId") != params.spaceId 
			Session.set("spaceId", params.spaceId);
		localStorage.setItem("spaceId:" + Meteor.userId(), params.spaceId);
		#Session.set("instanceId", null);

		console.log "call get_instance_data"

		BlazeLayout.render 'masterLayout',
			main: "workflow_main"
			
		$(document.body).addClass "loading";

		WorkflowManager.callInstanceDataMethod params.instanceId, ()->
			console.log "response get_instance_data" 

			Session.set("judge", null);
			Session.set("next_step_id", null);
			Session.set("next_step_multiple", null);
			Session.set("next_user_multiple", null);
			Session.set("instanceId", params.instanceId);
			Session.set("box", params.box);


			$(document.body).removeClass "loading";
			$(".workflow-main").addClass("instance-show")


	triggersExit: [
		()->
	]
