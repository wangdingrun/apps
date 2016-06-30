Template.workflow_main.helpers 

	instanceId: ->
		return Session.get("instanceId")

	subsReady: ->
		return FlowRouter.subsReady();

Template.workflow_main.onCreated ->


Template.workflow_main.onRendered ->
