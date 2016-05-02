Template.dock.helpers
		
	user: ->
		return Meteor.user();

	displayName: ->

		if Meteor.user()
			return Meteor.user().displayName()
		else
			return " "
	
	email: ->
		if Meteor.user()
			if Meteor.user().emails and Meteor.user().emails.length >0
				return Meteor.user().emails[0].address
		return ""

	avatar: ->
		return Meteor.user()?.avatarURL()


	urlPrefix: ->
		return __meteor_runtime_config__.ROOT_URL_PATH_PREFIX
		


Template.dock.onRendered ->
	
	$('html').addClass "dockOnTop"

	$('.ui.dropdown').dropdown({on: 'hover'});


Template.dock.events

	"click .ui.menu a.item": ->
		$(this).addClass('active').siblings().removeClass('active')
