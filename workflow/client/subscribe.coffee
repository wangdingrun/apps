Steedos.subs = {}

Steedos.subsReady = () ->
	subsReady = true;
	_.each Steedos.subs, (sub) ->
		if !sub.ready()
			subsReady = false;
	return subsReady


Meteor.startup ->
	Tracker.autorun (c)->

		Steedos.subs.my_spaces = Meteor.subscribe "my_spaces", Meteor.userId(), ()->
			# 如果只有一个工作区，自动跳转
			if db.spaces.find().count() == 1   
				FlowRouter.go("/space/" + db.spaces.findOne()._id + "/")
				return true
			# 自动跳转到之前选中的工作区。
			if !Session.get("spaceId")
				savedSpaceId = localStorage.getItem("spaceId")
				if savedSpaceId
					if db.spaces.find({_id: savedSpaceId}).count() == 1  
						Session.set("spaceId", savedSpaceId) 
						FlowRouter.go "/space/" + savedSpaceId + "/";
						return true

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

