Setup.validate = ()->

	userId = Accounts._storedUserId()
	loginToken = Accounts._storedLoginToken()

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
		if data.webservices
			Steedos.settings.webservices = data.webservices
			

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


Accounts.onLogin ()->
	Meteor.startup ->
		Setup.validate();