Template.sidebar.helpers

	apps: ()->
		if Steedos.isMobile()
			return db.apps.find({mobile: true, menu:true}, {sort: {sort_no:1}});
		else
			return db.apps.find({desktop: true, menu:true}, {sort: {sort_no:1}});

	displayName: ->

		if Meteor.user()
			return Meteor.user().displayName()
		else
			return " "
	
	avatar: ->
		return Meteor.absoluteUrl("/avatar/" + Meteor.userId());

	spaceId: ->
		if Session.get("spaceId")
			return Session.get("spaceId")
		else
			return localStorage.getItem("spaceId:" + Meteor.userId())

	menuClass: (app_id)->
		path = Session.get("router-path")
		if path?.startsWith "/" + app_id or path?.startsWith "/app/" + app_id
			return "active";

	badge: (app_id)->
		app = db.apps.findOne(app_id)
		if app && app.url.startsWith("/workflow")
			c = db.box_counts.findOne(Steedos.getSpaceId());
			if c
				return c.inbox_count;

	
