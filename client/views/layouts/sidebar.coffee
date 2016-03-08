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
		if c && (c.inbox_count > 0)
			return c.inbox_count;
		return;

	draft_count: ->
		c = db.box_counts.findOne(Session.get("spaceId"));
		if c && (c.draft_count > 0)
			return c.draft_count;
		return;

	progress_count: ->
		c = db.box_counts.findOne(Session.get("spaceId"));
		if c && (c.progress_count > 0)
			return c.progress_count;
		return;

	finished_count: ->
		c = db.box_counts.findOne(Session.get("spaceId"));
		if c && (c.finished_count > 0)
			return c.finished_count;
		return;