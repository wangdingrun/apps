Template.instance_list.helpers
		
	instances: ->
		return db.instances.find();

	boxName: ->
		return Session.get("box");