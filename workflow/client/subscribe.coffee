Meteor.startup ->
	Tracker.autorun =>
		if Meteor.userId()
			Meteor.subscribe "my_spaces", ()->
				# 如果只有一个工作区，自动跳转
				if db.spaces.find().count() == 1   
					FlowRouter.go("/space/" + db.spaces.findOne()._id + "/inbox/")
					return true
				# 自动跳转到之前选中的工作区。
				savedSpaceId = localStorage.getItem("spaceId")
				if savedSpaceId
					if db.spaces.find({_id: savedSpaceId}).count() == 1   
						FlowRouter.go "/space/" + savedSpaceId + "/inbox/";
						return true


FlowRouter.subscriptions = ->


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

