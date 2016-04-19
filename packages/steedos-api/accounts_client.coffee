# call validate when login success
Steedos = {}
Steedos.setupValidate = ()->
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

Accounts.onLogin ()->
	Steedos.setupValidate();

Meteor.startup ->
	if Meteor.userId
		Steedos.setupValidate();
