# call validate when login success
Setup.loginWithCookie = (onSuccess) ->
	userId = Cookies.get("X-User-Id")
	authToken = Cookies.get("X-Auth-Token")
	console.log "cookie login for " + userId
	if userId and authToken
		if Meteor.userId() != userId
			Accounts.connection.setUserId(userId);
			Accounts.loginWithToken authToken,  (err) ->
				if (err) 
					Meteor._debug("Error logging in with token: " + err);
					Accounts.makeClientLoggedOut();
				else if onSuccess
					onSuccess();


Setup.validate = ()->
	userId = Accounts._storedUserId()
	loginToken = Accounts._storedLoginToken()
	if (userId == Cookies.get("X-User-Id") and (loginToken == Cookies.get("X-Auth-Token")))
		return
	requestData = {}
	if userId and loginToken
		requestData = 
			"X-User-Id": userId
			"X-Auth-Token": loginToken
	$.ajax
		type: "POST",
		url: Meteor.absoluteUrl("api/setup/validate"),
		contentType: "application/json",
		dataType: 'json',
		data: JSON.stringify(requestData),
		xhrFields: 
			withCredentials: true
		crossDomain: true
	.done ( data ) ->
		# login by cookie
		# Setup.loginWithCookie();

		# if data.userId and data.authToken and not userId

		# 	userId = data.userId
		# 	loginToken = data.authToken

		# 	console.log "sso login for " + userId
		# 	userId && Accounts.connection.setUserId(userId);
		# 	Accounts.loginWithToken loginToken,  (err) ->
		# 		if (err) 
		# 			Meteor._debug("Error logging in with token: " + err);
		# 			Accounts.makeClientLoggedOut();
			
		# 		# if FlowRouter
		# 		# 	FlowRouter.go("/")
		# 		# else
		# 		# 	document.location.href = Meteor.absoluteUrl ""
		
			


Setup.logout = () ->

		$.ajax
			type: "POST",
			url: Meteor.absoluteUrl("api/setup/logout"),
			dataType: 'json',
			xhrFields: 
			   withCredentials: true
			crossDomain: true,
		.done ( data ) ->
			console.log(data)


Meteor.startup ->
	if (!Accounts._storedUserId())
		Setup.loginWithCookie()
	Accounts.onLogin ()->
		Setup.validate();