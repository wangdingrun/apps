Template.sidebar.helpers

	apps: ()->
		return db.apps.core_apps_array;

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
		if app_id == "workflow"
			c = db.box_counts.findOne(Steedos.getSpaceId());
			if c
				return c.inbox_count;

	
