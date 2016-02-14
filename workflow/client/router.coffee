

FlowRouter.route '/workflow/pending', 
	action: (params, queryParams)->
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "workflow_pending"


FlowRouter.route '/workflow/instance/:instanceId', 
	action: (params, queryParams)->
		Session.set("instanceId", params.instanceId)
		instance = db.instances.findOne(Session.get("instanceId"));
		if instance 
			Session.set("formId", instance.form)
			Session.set("flowId", instance.flow)

			BlazeLayout.render 'masterLayout',
				main: "instanceform"
	triggersExit: [
		()->
			Session.set("formId", null)
			Session.set("flowId", null)
			Session.set("instanceId", null)
	]
