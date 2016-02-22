

FlowRouter.route '/workflow/inbox', 
	action: (params, queryParams)->
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instance_list"


FlowRouter.route '/workflow/inbox/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "inbox");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instance_list"

FlowRouter.route '/workflow/outbox/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "outbox");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instance_list"


FlowRouter.route '/workflow/draft/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "draft");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instance_list"


FlowRouter.route '/workflow/pending/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "pending");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instance_list"


FlowRouter.route '/workflow/completed/:spaceId', 
	action: (params, queryParams)->
		Session.set("spaceId", params.spaceId);
		Session.set("box", "completed");
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "instance_list"


FlowRouter.route '/workflow/instance/:instanceId', 
	action: (params, queryParams)->
		Session.set("instanceId", params.instanceId)
		BlazeLayout.render 'masterLayout',
			main: "instanceform"
	triggersExit: [
		()->
			Session.set("instanceId", null)
	]
