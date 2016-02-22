Meteor.startup ->
	Meteor.subscribe "my_spaces"

	Tracker.autorun ->
		#Meteor.subscribe "instances_inbox", Session.get("spaceId")
		Meteor.subscribe "instances_list", Session.get("spaceId"), Session.get("box")
		
		Meteor.subscribe "instance_data", Session.get("instanceId"),
			onReady: ->
				instance = db.instances.findOne(Session.get("instanceId"));
				if instance 
					Session.set("formId", instance.form)
					Session.set("flowId", instance.flow)
					Session.set("spaceId", instance.space)
			onStop: ->
				Session.set("formId", null)
				Session.set("flowId", null)


		Meteor.subscribe "form_data", Session.get("formId")
		Meteor.subscribe "flow_data", Session.get("flowId")
