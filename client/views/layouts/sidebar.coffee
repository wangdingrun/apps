Template.sidebar.helpers

	displayName: ->

		if Meteor.user()
			return Meteor.user().displayName()
		else
			return " "

	urlPrefix: ->
		return __meteor_runtime_config__.ROOT_URL_PATH_PREFIX
		
	avatar: ->
		return Meteor.absoluteUrl("/avatar/" + Meteor.userId());

	spaceId: ->
		return Session.get("spaceId");

	boxClass: (boxName)->
		if Session.get("box") == boxName
			return "active";

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

	isAdmin: ->
		s = db.spaces.findOne(Session.get('spaceId'))
		if s
			return s.admins.includes(Meteor.userId())
		return false

Template.sidebar.onRendered ->

    if !Steedos.isMobile()
        $(".sidebar").perfectScrollbar();