Template.sidebar.helpers

	displayName: ->

		if Meteor.user()
			return Meteor.user().displayName()
		else
			return " "
	
	avatar: ->
		return Meteor.user()?.avatarURL()

	spaceId: ->
		return Session.get("spaceId");

	pending_count: ->
		c = db.pending_counts.findOne(Session.get("spaceId"));
		if c 
			return c.pending_count;
		return 0;