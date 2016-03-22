Meteor.startup ->
	Meteor.subscribe "my_spaces"

	Tracker.autorun ->
		Meteor.subscribe "space_users", Session.get("spaceId")
		Meteor.subscribe "organizations", Session.get("spaceId")
		Meteor.subscribe "flow_roles", Session.get("spaceId")
		Meteor.subscribe "flow_positions", Session.get("spaceId")

		Meteor.subscribe "instances_list", Session.get("spaceId"), Session.get("box"), Session.get("flowId")
		
		Meteor.subscribe "instance_data", Session.get("instanceId"),
			onReady: ->
				instance = db.instances.findOne(Session.get("instanceId"));
				if instance 
					Session.set("formId", instance.form)
					Session.set("flowId", instance.flow)
					Session.set("spaceId", instance.space)
			onStop: ->
				Session.set("formId", null);
				if Session.get("box") != "monitor"
					Session.set("flowId", null)


		Meteor.subscribe "form_data", Session.get("formId")
		Meteor.subscribe "flow_data", Session.get("flowId")
		
		Meteor.subscribe "categories", Session.get("spaceId")
		Meteor.subscribe "forms", Session.get("spaceId")
		Meteor.subscribe "flows", Session.get("spaceId")
		Meteor.subscribe "box_counts", Session.get("spaceId")

		Meteor.subscribe "cfs_instances"

		Meteor.subscribe "user_data"


