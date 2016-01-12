
FlowRouter.route '/workflow/instance/:instance_id', 
	action: ->
		BlazeLayout.render 'masterLayout',
			main: "instanceform"
