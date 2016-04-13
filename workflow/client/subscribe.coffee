Meteor.startup ->
	Meteor.subscribe "my_spaces"

	Tracker.autorun ->
		if Session.get("spaceId")
			Meteor.subscribe "space_users", Session.get("spaceId")
			Meteor.subscribe "organizations", Session.get("spaceId")
			Meteor.subscribe "flow_roles", Session.get("spaceId")
			Meteor.subscribe "flow_positions", Session.get("spaceId")

			
			Meteor.subscribe "categories", Session.get("spaceId")
			Meteor.subscribe "forms", Session.get("spaceId")
			Meteor.subscribe "flows", Session.get("spaceId")
			Meteor.subscribe "box_counts", Session.get("spaceId")

			Meteor.subscribe "cfs_instances", Session.get("instanceId")