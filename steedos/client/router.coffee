FlowRouter.notFound = 
	action: ()->
		if !Meteor.userId()
			BlazeLayout.render 'loginLayout',
				main: "not-found"
		else
			BlazeLayout.render 'masterLayout',
				main: "not-found"

FlowRouter.triggers.enter [()->
	Session.set("router-path", FlowRouter.current().path)
]

FlowRouter.route '/', 
	action: (params, queryParams)->
		if (!Meteor.userId())
			FlowRouter.go "/steedos/sign-in";
		else 
			FlowRouter.go "/steedos/springboard";
		

FlowRouter.route '/steedos', 
	action: (params, queryParams)->
		if !Meteor.userId()
			FlowRouter.go "/steedos/sign-in";
			return true
		else
			FlowRouter.go "/steedos/springboard";


FlowRouter.route '/steedos/logout', 
	action: (params, queryParams)->
		#AccountsTemplates.logout();
		Meteor.logout ()->
			Setup.logout();
			Session.set("spaceId", null);
			FlowRouter.go("/");


FlowRouter.route '/steedos/profile', 
	action: (params, queryParams)->
		if Meteor.userId()
			BlazeLayout.render 'masterLayout',
				main: "profile"


FlowRouter.route '/steedos/admin', 
	action: (params, queryParams)->
		if Meteor.userId()
			BlazeLayout.render 'masterLayout',
				main: "admin_home"


FlowRouter.route '/steedos/springboard', 
	action: (params, queryParams)->
		if !Meteor.userId()
			FlowRouter.go "/steedos/sign-in";
			return true

		NavigationController.reset();
		
		BlazeLayout.render 'masterLayout',
			main: "springboard"


FlowRouter.route '/steedos/space', 
	action: (params, queryParams)->
		if !Meteor.userId()
			FlowRouter.go "/steedos/sign-in";
			return true

		BlazeLayout.render 'loginLayout',
			main: "space_select"


FlowRouter.route '/steedos/space/info', 
	action: (params, queryParams)->
		if !Meteor.userId()
			FlowRouter.go "/steedos/sign-in";
			return true

		BlazeLayout.render 'masterLayout',
			main: "space_info"


FlowRouter.route '/steedos/help', 
	action: (params, queryParams)->
		locale = Steedos.getLocale()
		country = locale.substring(3)
		window.open("http://www.steedos.com/" + country + "/help/", '_blank', 'EnableViewPortScale=yes')

FlowRouter.route '/steedos/customize_apps',
	action: (params, queryParams)->
		spaceId = Steedos.getSpaceId()
		if spaceId
			space = db.spaces.findOne(spaceId)
			if !space?.is_paid
				swal(t("steedos_customize_apps"), t("steedos_only_paid"), "error")
			else
				FlowRouter.go("/admin/view/apps")

FlowRouter.route '/designer', 
	action: (params, queryParams)->
		if !Meteor.userId()
			FlowRouter.go "/steedos/sign-in";
			return true
		
		url = Meteor.absoluteUrl("applications/designer/current/" + Steedos.getLocale() + "/"+ "?spaceId=" + Steedos.getSpaceId());
		
		Steedos.openWindow(url);
		
		FlowRouter.go "/steedos/springboard"

FlowRouter.route '/app/:app_id', 
	action: (params, queryParams)->
		if !Meteor.userId()
			FlowRouter.go "/steedos/sign-in";
			return true
		
		app = db.apps.findOne(params.app_id)
		if !app
			FlowRouter.go("/steedos/springboard")

		if app.internal
			FlowRouter.go(app.url)
			return

		url = Meteor.absoluteUrl("api/setup/sso/" + app._id + "?spaceId=" + Steedos.getSpaceId());

		Steedos.openWindow(url);
		
		FlowRouter.go "/steedos/springboard"
