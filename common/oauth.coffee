if Meteor.isServer

	if Meteor.settings.oauth
		if Meteor.settings.oauth.bqq
			ServiceConfiguration.configurations.remove
				service: "bqq"
			
			ServiceConfiguration.configurations.insert
				service: "bqq",
				clientId: Meteor.settings.oauth.bqq.clientId,
				scope:'get_user_info',
				secret: Meteor.settings.oauth.bqq.secret
