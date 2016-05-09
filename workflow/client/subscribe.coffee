
FlowRouter.subscriptions = ->
	Meteor.subscribe("my_spaces")
	Tracker.autorun =>
		if Session.get("spaceId")
			@register 'space_users', Meteor.subscribe("space_users", Session.get("spaceId"))
			@register 'organizations', Meteor.subscribe("organizations", Session.get("spaceId"))
			@register 'flow_roles', Meteor.subscribe("flow_roles", Session.get("spaceId"))
			@register 'flow_positions', Meteor.subscribe("flow_positions", Session.get("spaceId"))

			
			@register 'categories', Meteor.subscribe("categories", Session.get("spaceId"))
			@register 'forms', Meteor.subscribe("forms", Session.get("spaceId"))
			@register 'flows', Meteor.subscribe("flows", Session.get("spaceId"))
			@register 'box_counts', Meteor.subscribe("box_counts", Session.get("spaceId"))

			@register 'cfs_instances', Meteor.subscribe("cfs_instances", Session.get("instanceId"))

