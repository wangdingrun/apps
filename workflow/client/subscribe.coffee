Steedos.subs = {}

Steedos.subsReady = () ->
	subsReady = true;
	_.each Steedos.subs, (sub) ->
		if !sub.ready()
			subsReady = false;
	return subsReady


Meteor.startup ->
	Tracker.autorun (c)->

		Steedos.subs.my_spaces = Meteor.subscribe "my_spaces", Meteor.userId()

		if Session.get("spaceId")
			Steedos.subs.space_users = Meteor.subscribe("space_users", Session.get("spaceId"))
			Steedos.subs.organizations = Meteor.subscribe("organizations", Session.get("spaceId"))
			Steedos.subs.flow_roles = Meteor.subscribe("flow_roles", Session.get("spaceId"))
			Steedos.subs.flow_positions = Meteor.subscribe("flow_positions", Session.get("spaceId"))

			
			Steedos.subs.categories = Meteor.subscribe("categories", Session.get("spaceId"))
			Steedos.subs.forms = Meteor.subscribe("forms", Session.get("spaceId"))
			Steedos.subs.flows = Meteor.subscribe("flows", Session.get("spaceId"))
			Steedos.subs.box_counts = Meteor.subscribe("box_counts", Session.get("spaceId"))

			Steedos.subs.cfs_instances = Meteor.subscribe("cfs_instances", Session.get("instanceId"))

