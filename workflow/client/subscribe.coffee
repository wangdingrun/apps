Meteor.startup ->
	Meteor.subscribe "my_spaces"

	Tracker.autorun ->
		Meteor.subscribe "instances_pending", Session.get("spaceId")
		Meteor.subscribe "instance_data", Session.get("instanceId")
		Meteor.subscribe "form_data", Session.get("formId")
		Meteor.subscribe "flow_data", Session.get("flowId")
