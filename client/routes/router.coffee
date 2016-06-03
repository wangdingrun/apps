FlowRouter.route '/', 
	action: (params, queryParams)->
		if (!Meteor.userId())
			FlowRouter.go "/sign-in";
		else 
			FlowRouter.go "/loading";
		


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
			BlazeLayout.render 'adminLayout',
				main: "profile"


FlowRouter.route '/space', 
	action: (params, queryParams)->
		if !Meteor.userId()
			FlowRouter.go "/sign-in";
			return true

		BlazeLayout.render 'masterLayout',
			main: "space_select"


FlowRouter.route '/loading', 
	action: (params, queryParams)->
		BlazeLayout.render 'masterLayout',
			main: "loading"



