Meteor.startup ->
	Steedos.settings.webservices = Meteor.settings.public.webservices

	if !Steedos.settings.webservices
		Steedos.settings.webservices =
			uuflow: 
				status: "active",
				url: "/"
			www: 
				status: "active",
				url: "/"
			s3: 
				status: "active",
				url: "/"
			chat:
				status: "active",
				url: "/chat/"
			workflow:
				status: "active",
				url: "/workflow/"
			admin: 
				status: "active",
				url: "/"
			push: 
				status: "active",
				url: "/pu/"
			keyvalue: 
				status: "active",
				url: "/"
			account: 
				status: "active",
				url: "/"
			contacts: 
				status: "active",
				url: "/"