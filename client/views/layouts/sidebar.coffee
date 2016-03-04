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

	inbox_count: ->
		c = db.box_counts.findOne(Session.get("spaceId"));
		if c 
			return c.inbox_count;
		return 0;

	draft_count: ->
		c = db.box_counts.findOne(Session.get("spaceId"));
		if c 
			return c.draft_count;
		return 0;

	progress_count: ->
		c = db.box_counts.findOne(Session.get("spaceId"));
		if c 
			return c.progress_count;
		return 0;

	finished_count: ->
		c = db.box_counts.findOne(Session.get("spaceId"));
		if c 
			return c.finished_count;
		return 0;