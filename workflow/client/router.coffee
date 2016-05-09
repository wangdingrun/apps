checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		redirect('/sign-in');


FlowRouter.route '/home/', 
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->
		Tracker.autorun (c) ->
			if FlowRouter.subsReady() is true
				Meteor.defer ->
					FlowRouter.go "/space/" + Session.get("spaceId") + "/inbox/"
				c.stop()



FlowRouter.route '/space/:spaceId/:box/', 
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
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

		Session.set("spaceId", params.spaceId);
		Session.set("instanceId", null);

		console.log "call get_instance_data"
		$(document.body).addClass "loading";
		WorkflowManager.callInstanceDataMethod params.instanceId, ()->
			console.log "response get_instance_data" 

			Session.set("instanceId", params.instanceId);
			Session.set("box", params.box);
			BlazeLayout.render 'masterLayout',
				main: "workflow_main"

			if (Steedos.isMobile())
				$(".instance-wrapper").show();
				$(".instance-list-wrapper").hide();
			else
				$(".instance-wrapper").show();
				$(".instance-list-wrapper").show();

			$(document.body).removeClass "loading";


	triggersExit: [
		()->
			Session.set("instanceId", null)
	]
