# call validate when login success
@SteedosAPI = {}

SteedosAPI.setupValidate = ()->
	userId = Accounts._storedUserId()
	loginToken = Accounts._storedLoginToken()
	requestData = {}
	if userId and loginToken
		requestData = 
			"X-User-Id": userId
			"X-Auth-Token": loginToken
	$.ajax
		type: "POST",
		url: Meteor.absoluteUrl("se/ws/1/validate"),
		contentType: "application/json",
		dataType: 'json',
		data: JSON.stringify(requestData),
		xhrFields: 
			withCredentials: true
		crossDomain: true
	.done ( data ) ->
		# login by cookie
		if data.userId and data.authToken and not userId

			userId = data.userId
			loginToken = data.authToken

			console.log "sso login for " + userId
			userId && Accounts.connection.setUserId(userId);
			Accounts.loginWithToken loginToken,  (err) ->
				if (err) 
					Meteor._debug("Error logging in with token: " + err);
					Accounts.makeClientLoggedOut();
			
				if FlowRouter
					FlowRouter.go("/")
				else
					document.location.href = Meteor.absoluteUrl ""
		
			


SteedosAPI.setupLogout = () ->

		$.ajax
			type: "POST",
			url: Meteor.absoluteUrl("se/ws/1/logout"),
			dataType: 'json',
			xhrFields: 
			   withCredentials: true
			crossDomain: true,
		.done ( data ) ->
			console.log(data)


Meteor.startup ->
	SteedosAPI.setupValidate();
	Accounts.onLogin ()->
		SteedosAPI.setupValidate();
