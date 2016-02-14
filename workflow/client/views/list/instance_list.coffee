Template.instance_list.helpers
		
	instances: ->
		return db.instances.find();

	boxName: ->
		return FlowRouter.getParam("box");