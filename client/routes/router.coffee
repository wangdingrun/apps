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
			SteedosAPI.setupLogout();
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

		if Session.get("spaceId")
			FlowRouter.go "/space/" + Session.get("spaceId");
			return true

		BlazeLayout.render 'loginLayout',
			main: "space_select"

