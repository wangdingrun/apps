
FlowRouter.route '/space', 
	action: (params, queryParams)->
		if !Meteor.userId()
			FlowRouter.go "/sign-in";
			return true

		BlazeLayout.render 'loginLayout',
			main: "space_select"

FlowRouter.route '/loading', 
	action: (params, queryParams)->
		BlazeLayout.render 'loginLayout',
			main: "loading"



