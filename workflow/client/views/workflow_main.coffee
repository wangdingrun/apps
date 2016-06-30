Template.workflow_main.helpers 

	instanceId: ->
		return Session.get("instanceId")

	subsReady: ->
		return Steedos.subsBootstrap.ready() and Steedos.subsSpace.ready();

Template.workflow_main.onCreated ->


Template.workflow_main.onRendered ->
