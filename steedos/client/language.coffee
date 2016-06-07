Meteor.startup ->

	Meteor.subscribe("userData")

	Tracker.autorun (c) ->
		user = Meteor.user()
		locale = Steedos.getLocale();

		if locale == "zh-cn"
			TAPi18n.setLanguage("zh-CN")
		else 
			TAPi18n.setLanguage("en")

