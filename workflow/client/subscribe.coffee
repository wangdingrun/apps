Steedos.subs = {}

Steedos.subsReady = () ->
	subsReady = true;
	_.each Steedos.subs, (sub) ->
		if !sub.ready()
			subsReady = false;
	return subsReady

Session.set("space_loaded", false)
Session.set("startup_loaded", false)
Meteor.startup ->

	Steedos.subs.my_spaces = Meteor.subscribe "my_spaces", Meteor.userId(), ()->
		Session.set("space_loaded", true)
		if (!Session.get("spaceId"))
			savedSpaceId = localStorage.getItem("spaceId:" + Meteor.userId())
			if savedSpaceId
				Session.set("spaceId", savedSpaceId) 
			else
				Session.set("spaceId", db.spaces.findOne()._id)
			FlowRouter.go "/space/" + Session.get("spaceId") + "/inbox/";

	Tracker.autorun (c)->
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


	# Tracker.autorun (c)->
	# 	if Steedos.subsReady()
	# 		debugger
			# # 如果只有一个工作区，自动跳转
			# if db.spaces.find().count() == 1   
			# 	Session.set("spaceId", db.spaces.findOne()._id)
			# 	FlowRouter.go("/space/" + db.spaces.findOne()._id + "/")
			# 	c.stop();
			# 	return true
			# # 自动跳转到之前选中的工作区。
			# if !Session.get("spaceId")
			# 	savedSpaceId = localStorage.getItem("spaceId:" + Meteor.userId())
			# 	if savedSpaceId
			# 		Session.set("spaceId", savedSpaceId) 
			# 		FlowRouter.go "/space/" + savedSpaceId + "/";
			# 		c.stop();
			# 		return true