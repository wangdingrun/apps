Meteor.startup ->
	Meteor.subscribe "my_spaces"

	Tracker.autorun ->
		Meteor.subscribe "space_users", Session.get("spaceId")
		Meteor.subscribe "organizations", Session.get("spaceId")
		Meteor.subscribe "flow_roles", Session.get("spaceId")
		Meteor.subscribe "flow_positions", Session.get("spaceId")

		Meteor.subscribe "instances_list", Session.get("spaceId"), Session.get("box"), Session.get("flowId")
		
		Meteor.subscribe "categories", Session.get("spaceId")
		Meteor.subscribe "forms", Session.get("spaceId")
		Meteor.subscribe "flows", Session.get("spaceId")
		Meteor.subscribe "box_counts", Session.get("spaceId")

		Meteor.subscribe "cfs_instances", Session.get("instanceId")