workflowRoutes = FlowRouter.group 
	prefix: '/workflow',
	name: 'workflow',
	triggersEnter: [
		(context, redirect) ->
			console.log('running workflow triggers');
			if !Meteor.userId()
				redirect('/sign-in');
	]
 


workflowRoutes.route '/inbox', 
	action: (params, queryParams)->
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"


workflowRoutes.route '/inbox/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "inbox");
		Session.set("flowId", undefined);
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"

workflowRoutes.route '/inbox/:spaceId/:instanceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("instanceId", params.instanceId);
		Session.set("box", "inbox");
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"
	triggersExit: [
		()->
			Session.set("instanceId", null)
	]

workflowRoutes.route '/outbox/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "outbox");
		Session.set("flowId", undefined);
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"

workflowRoutes.route '/outbox/:spaceId/:instanceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("instanceId", params.instanceId);
		Session.set("box", "outbox");
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"
	triggersExit: [
		()->
			Session.set("instanceId", null)
	]


workflowRoutes.route '/draft/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "draft");
		Session.set("flowId", undefined);
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"

workflowRoutes.route '/draft/:spaceId/:instanceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("instanceId", params.instanceId);
		Session.set("box", "draft");
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"
	triggersExit: [
		()->
			Session.set("instanceId", null)
	]


workflowRoutes.route '/pending/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "pending");
		Session.set("flowId", undefined);
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"

workflowRoutes.route '/pending/:spaceId/:instanceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("instanceId", params.instanceId);
		Session.set("box", "pending");
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"
	triggersExit: [
		()->
			Session.set("instanceId", null)
	]


workflowRoutes.route '/completed/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "completed");
		Session.set("flowId", undefined);
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"

workflowRoutes.route '/completed/:spaceId/:instanceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("instanceId", params.instanceId);
		Session.set("box", "completed");
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"
	triggersExit: [
		()->
			Session.set("instanceId", null)
	]


workflowRoutes.route '/monitor/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "monitor");
		Session.set("flowId", undefined);
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"


workflowRoutes.route '/monitor/:spaceId/:instanceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("instanceId", params.instanceId);
		Session.set("box", "monitor");
		BlazeLayout.render 'masterLayout',
			main: "workflow_main"
	triggersExit: [
		()->
			Session.set("instanceId", null)
	]

