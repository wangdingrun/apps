# call validate when login success
@SteedosAPI = {}
SteedosAPI.setupValidate = ()->
	userId = Accounts._storedUserId()
	loginToken = Accounts._storedLoginToken()
	if userId and loginToken
		$.ajax
			type: "POST",
			url: "/se/ws/1/validate",
			contentType: "application/json"
			dataType: 'json',
			data:
				JSON.stringify
					"X-User-Id": userId
					"X-Auth-Token": loginToken
			xhrFields: 
			   withCredentials: true
			crossDomain: true,
		.done ( data ) ->
			#console.log(data)

SteedosAPI.setupLogout = () ->

		$.ajax
			type: "POST",
			url: "/se/ws/1/logout",
			dataType: 'json',
			xhrFields: 
			   withCredentials: true
			crossDomain: true,
		.done ( data ) ->
			console.log(data)

Accounts.onLogin ()->
	SteedosAPI.setupValidate();

Meteor.startup ->
	if Meteor.userId
		SteedosAPI.setupValidate();
