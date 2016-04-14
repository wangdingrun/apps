workflowRoutes = FlowRouter.group 
	prefix: '/workflow',
	name: 'workflow',
	triggersEnter: [
		(context, redirect) ->
			console.log('running workflow triggers');
			if !Meteor.user()
				redirect('/sign-in');
	]
 


workflowRoutes.route '/inbox', 
	action: (params, queryParams)->
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instance_list"


workflowRoutes.route '/inbox/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "inbox");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instance_list"

workflowRoutes.route '/inbox/:spaceId/:instanceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("instanceId", params.instanceId);
		Session.set("box", "inbox");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instanceform"
	triggersExit: [
		()->
			Session.set("instanceId", null)
	]

workflowRoutes.route '/outbox/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "outbox");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instance_list"

workflowRoutes.route '/outbox/:spaceId/:instanceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("instanceId", params.instanceId);
		Session.set("box", "outbox");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instanceform"
	triggersExit: [
		()->
			Session.set("instanceId", null)
	]


workflowRoutes.route '/draft/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "draft");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instance_list"

workflowRoutes.route '/draft/:spaceId/:instanceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("instanceId", params.instanceId);
		Session.set("box", "draft");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instanceform"
	triggersExit: [
		()->
			Session.set("instanceId", null)
	]


workflowRoutes.route '/pending/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "pending");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instance_list"

workflowRoutes.route '/pending/:spaceId/:instanceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("instanceId", params.instanceId);
		Session.set("box", "pending");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instanceform"
	triggersExit: [
		()->
			Session.set("instanceId", null)
	]


workflowRoutes.route '/completed/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "completed");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instance_list"

workflowRoutes.route '/completed/:spaceId/:instanceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("instanceId", params.instanceId);
		Session.set("box", "completed");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instanceform"
	triggersExit: [
		()->
			Session.set("instanceId", null)
	]


workflowRoutes.route '/monitor/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "monitor");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "monitor"


workflowRoutes.route '/monitor/:spaceId/:flowId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("flowId", params.flowId);
		Session.set("box", "monitor");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instance_list"

workflowRoutes.route '/monitor/:spaceId/:flowId/:instanceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("flowId", params.flowId);
		Session.set("instanceId", params.instanceId);
		Session.set("box", "monitor");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instanceform"
	triggersExit: [
		()->
			Session.set("instanceId", null)
	]


workflowRoutes.route '/instance/:instanceId', 
	action: (params, queryParams)->
		Session.set("instanceId", params.instanceId)
		BlazeLayout.render 'masterLayout',
			main: "instanceform"
	triggersExit: [
		()->
			Session.set("instanceId", null)
	]
