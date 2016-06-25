Template.registerHelper 'absoluteUrl', ->
	return Meteor.absoluteUrl()

Template.registerHelper 'urlPrefix', ->
	return __meteor_runtime_config__.ROOT_URL_PATH_PREFIX

Template.registerHelper 'isMobile', ->
	return $(window).width()<767

Template.registerHelper 'userId', ->
	return Meteor.userId()

Template.registerHelper 'spaceId', ->
	if Steedos.getSpaceId()
		return Steedos.getSpaceId()
	else
		return "none";

Template.registerHelper 'isCloudAdmin', ->
	return Meteor.user()?.is_cloudadmin

Template.registerHelper 'locale', ->
	return Steedos.getLocale()

Template.registerHelper 'country', ->
	locale = Steedos.getLocale()
	if locale == "zh-cn"
		return "cn"
	else
		return "us"

Template.registerHelper 'fromNow', (posted)->
	return moment(posted).fromNow()

Template.registerHelper 'badge', (app_id)->
	app = db.apps.findOne(app_id)
	if app && app.url.startsWith("/workflow")
		c = Steedos.getBadge(Steedos.getSpaceId())
		if c > 0
			return c
	if app && app.url.startsWith("/chat")
		subscriptions = db.rocketchat_subscription.find().fetch()
		count = 0;
		_.each subscriptions, (s)->
			count = count + s.unread
		if count >0
			return count

Template.registerHelpers

	equals: (a, b)->
		return a == b
		
	spaceName: ->
		if Session.get("spaceId")
			space = db.spaces.findOne(Session.get("spaceId"))
			if space
				return space.name

	isSpaceAdmin: ->
		if Session.get('spaceId')
			s = db.spaces.findOne(Session.get('spaceId'))
			if s
				return s.admins.includes(Meteor.userId())

	isSpaceOwner: ->
		if Session.get('spaceId')
			s = db.spaces.findOne(Session.get('spaceId'))
			if s
				return s.owner == Meteor.userId()

	isPaid: (app)->
		if !app
			app = "workflow"
		if Session.get('spaceId')
			space = db.spaces.findOne(Session.get('spaceId'))
			if space?.apps_paid?.length >0
				return _.indexOf(space.apps_paid, app)>=0 
