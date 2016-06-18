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

Template.registerHelper 'locale', ->
	return Steedos.getLocale()

Template.registerHelper 'country', ->
	locale = Steedos.getLocale()
	if locale == "zh-cn"
		return "cn"
	else
		return "us"


Template.registerHelper 'badge', (app_id)->
	app = db.apps.findOne(app_id)
	if app && app.url.startsWith("/workflow")
		c = db.box_counts.findOne(Steedos.getSpaceId());
		if c?.inbox_count >0
			return c.inbox_count;
	if app && app.url.startsWith("/chat")
		subscriptions = db.rocketchat_subscription.find().fetch()
		count = 0;
		_.each subscriptions, (s)->
			count = count + s.unread
		if count >0
			return count
