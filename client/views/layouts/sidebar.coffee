Template.sidebar.helpers

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

	menuClass: (urlPrefix)->
		if FlowRouter.current().path.startsWith urlPrefix
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


# Template.sidebar.onRendered ->

#     if !Steedos.isMobile()
#         $(".sidebar").perfectScrollbar();