Meteor.startup ->
	Tracker.autorun (c)->
		Meteor.subscribe "my_spaces", Meteor.userId(), ()->
			debugger
			# 如果只有一个工作区，自动跳转
			if db.spaces.find().count() == 1   
				FlowRouter.go("/space/" + db.spaces.findOne()._id + "/")
				return true
			# 自动跳转到之前选中的工作区。
			if !Session.get("spaceId")
				savedSpaceId = localStorage.getItem("spaceId")
				if savedSpaceId
					if db.spaces.find({_id: savedSpaceId}).count() == 1   
						FlowRouter.go "/space/" + savedSpaceId + "/";
						return true

		if Session.get("spaceId")
			Meteor.subscribe("space_users", Session.get("spaceId"))
			Meteor.subscribe("organizations", Session.get("spaceId"))
			Meteor.subscribe("flow_roles", Session.get("spaceId"))
			Meteor.subscribe("flow_positions", Session.get("spaceId"))

			
			Meteor.subscribe("categories", Session.get("spaceId"))
			Meteor.subscribe("forms", Session.get("spaceId"))
			Meteor.subscribe("flows", Session.get("spaceId"))
			Meteor.subscribe("box_counts", Session.get("spaceId"))

			Meteor.subscribe("cfs_instances", Session.get("instanceId"))

