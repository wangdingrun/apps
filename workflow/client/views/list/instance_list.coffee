Template.instance_list.helpers
		
	instances: ->
		return db.instances.find({}, {sort: {modified: -1}});

	boxName: ->
		return Session.get("box");

	spaceId: ->
		return Session.get("spaceId");


Template.instance_list.events

	'hidden.bs.modal #createInsModal': (event)->
		insId = Session.get("instanceId");
		if insId
			FlowRouter.go("/workflow/instance/" + insId);