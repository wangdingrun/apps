checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		redirect('/steedos/sign-in');


FlowRouter.route '/workflow',
	action: (params, queryParams)->
		FlowRouter.go "/workflow/space/" + Steedos.getSpaceId()


FlowRouter.route '/workflow/space/:spaceId', 
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->
		Steedos.setSpaceId(params.spaceId)
		BlazeLayout.render 'masterLayout',
			main: "workflow_home"


FlowRouter.route '/workflow/space/:spaceId/:box/', 
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->
		Steedos.setSpaceId(params.spaceId)
		
		Session.set("box", params.box);
		Session.set("flowId", undefined);
		#Session.set("instanceId", null); 
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"
		
		$(".workflow-main").removeClass("instance-show")


FlowRouter.route '/workflow/space/:spaceId/:box/:instanceId', 
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->

		Steedos.setSpaceId(params.spaceId)
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
