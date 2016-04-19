Cookies = Npm.require("cookies")

JsonRoutes.add "post", "/se/ws/1/validate", (req, res, next) ->

	cookies = new Cookies( req, res );

	# first check request body
	if req.body
		userId = req.body["X-User-Id"]
		authToken = req.body["X-Auth-Token"]

	# then check cookie
	if !userId or !authToken
		userId = cookies.get("X-User-Id")
		authToken = cookies.get("X-Auth-Token")

	if userId and authToken
		hashedToken = Accounts._hashLoginToken(authToken)
		user = Meteor.users.findOne
			_id: userId,
			"services.resume.loginTokens.hashedToken": hashedToken
		if user
			# set cookie to response
			cookies.set("X-User-Id", userId)
			cookies.set("X-Auth-Token", authToken)
			JsonRoutes.sendResult res, 
				data: 
					apps: []
					dsInfo: 
						dsid: user._id
						steedosId: user.steedos_id
						name: user.name
						primaryEmail: user.email
						statusCode: 2
					instance: "1329598861"
					isExtendedLogin: true
					requestInfo:
						country: "CN"
						region: "SH"
						timezone: "GMT+8"
					webservices:
						Meteor.settings.public.webservices
			return


	JsonRoutes.sendResult res, 
		code: 401,
		data: 
			"error": "Validate Request -- Missing X-Auth-Token", 
			"instance": "1329598861", 
			"success": false


JsonRoutes.add "post", "/se/ws/1/logout", (req, res, next) ->

	cookies = new Cookies( req, res );
	cookies.set("X-User-Id", "")
	cookies.set("X-Auth-Token", "")

	res.end();
