Template.instance_list.helpers
		
	instances: ->
		return db.instances.find({}, {sort: {modified: -1}});

	boxName: ->
		return Session.get("box");