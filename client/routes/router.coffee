FlowRouter.route '/', 
	action: (params, queryParams)->
		if (!Meteor.userId())
			FlowRouter.go "/sign-in";
		else 
			FlowRouter.go "/space";
		


FlowRouter.route '/logout', 
	action: (params, queryParams)->
		#AccountsTemplates.logout();
		Meteor.logout ()->
			Setup.logout();
			Session.set("spaceId", null);
			FlowRouter.go("/");


FlowRouter.route '/account/profile', 
	action: (params, queryParams)->
		if Meteor.userId()
			BlazeLayout.render 'masterLayout',
				main: "profile"


FlowRouter.route '/space', 
	action: (params, queryParams)->
		if !Meteor.userId()
			FlowRouter.go "/sign-in";
			return true

		BlazeLayout.render 'masterLayout',
			main: "space_select"


