Cookies = Npm.require("cookies")

JsonRoutes.add "post", "/api/setup/validate", (req, res, next) ->

	cookies = new Cookies( req, res );

	# get cookie from request
	userId = cookies.get("X-User-Id")
	authToken = cookies.get("X-Auth-Token")

	if !userId or !authToken
		if req.body
			userId = req.body["X-User-Id"]
			authToken = req.body["X-Auth-Token"]

	if userId and loginToken
		user = Meteor.users.findOne
			_id: userId,
			"services.resume.loginTokens.hashedToken": authToken
		if user
			# set cookie to response
			cookies.set("X-User-Id", userId)
			cookies.set("X-Auth-Token", authToken)
			JsonRoutes.sendResult res, 
				data: user


	JsonRoutes.sendResult res, 
		code: 401,
		data: 
			"error": "Validate Request -- Missing X-STEEDOS-WEBAUTH-TOKEN cookie", 
			"instance": "1329598861", 
			"success": false
