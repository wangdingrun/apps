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