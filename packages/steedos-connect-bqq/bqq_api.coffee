# BQQ.app =
# 	app_id: "200626779",
# 	app_secret: "UkQ6G6gFJwJBfYuv"


BQQ.company =      
	company_id: 'c4609934c326caf9fd0053823bb99947',
	company_token: '07ded6f5c4c31706018434f88a94b461',
	refresh_token: '8cfbcf279c61028750ad5bcec13d8b03',


config = ServiceConfiguration.configurations.findOne({service: 'bqq'});

BQQ.corporationGet = ()->
	try
		response = HTTP.get(
			"https://openapi.b.qq.com/api/corporation/get", 
			{
				params: 
					app_id: config.clientId,
					app_secret: OAuth.openSecret(config.secret),
					company_id: BQQ.company.company_id,
					company_token: BQQ.company.company_token,
					client_ip: "0.0.0.0",
					oauth_version: 2
				
			}
		);

		console.log(response);
		if (response.error_code) 
			throw response.msg;

	catch err
		throw _.extend(new Error("Failed to complete OAuth handshake with QQ. " + err.message), {response: err.response});
