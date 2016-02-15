FlowRouter.route '/', 
	action: (params, queryParams)->
		if (!Meteor.userId())
			FlowRouter.go("/sign-in");
		else
			FlowRouter.go("/workflow/inbox");



FlowRouter.route '/logout', 
	action: (params, queryParams)->
		AccountsTemplates.logout();


FlowRouter.route '/account/profile', 
	action: (params, queryParams)->
		if Meteor.user()
			BlazeLayout.render 'masterLayout',
				main: "profile"

