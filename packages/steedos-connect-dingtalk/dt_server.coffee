
Accounts.addAutopublishFields({
	forLoggedInUser: ['services.dingtalk'],
	forOtherUsers: ['services.dingtalk.name']
});

Dingtalk.oauth = 
	config: ServiceConfiguration.configurations.findOne({service: 'dingtalk'}),
	access_token: null


Dingtalk.refreshAccessToken = () ->
	response = HTTP.get "https://oapi.dingtalk.com/sns/gettoken", 
		params: 
			appid: Dingtalk.oauth.config.clientId,
			appsecret: OAuth.openSecret(Dingtalk.oauth.config.secret),
	   
	console.log(response.data)

	if response.data && response.data.access_token
		Dingtalk.oauth.access_token = response.data.access_token
		setTimeout(Dingtalk.refreshAccessToken, 60 * 1000 * 110)
	else 
		setTimeout(Dingtalk.refreshAccessToken, 2000)


Dingtalk.refreshAccessToken();


Dingtalk.getTokenResponse = (query) ->

	response = {}

	if (!Dingtalk.oauth.config)
		throw new ServiceConfiguration.ConfigError();

	if (!Dingtalk.oauth.access_token)
		throw new Error("Dingtalk app access token not found.")

	if (!query.code)
		throw new Error("Dingtalk oauth2 code not found.")

	url = "https://oapi.dingtalk.com/sns/get_persistent_code?access_token=" + Dingtalk.oauth.access_token;
	pc = HTTP.post url, 
		data: 
			tmp_auth_code: query.code,
			access_token: Dingtalk.oauth.access_token
		headers: 
			"Content-Type": "application/json"
		
	console.log(pc.data)

	if (!pc.data || !pc.data.persistent_code || !pc.data.openid)
		throw new Error("Dingtalk persistent_code or openid not found.")

	response.openid = pc.data.openid
	response.unionid = pc.data.unionid
	response.persistent_code = pc.data.persistent_code

	sns = HTTP.post "https://oapi.dingtalk.com/sns/get_sns_token?access_token=" + Dingtalk.oauth.access_token, 
		data: 
			access_token: Dingtalk.oauth.access_token,
			openid: response.openid,
			persistent_code: response.persistent_code
		headers:
			"Content-Type": "application/json"
	
	console.log(sns.data)

	if (!sns.data || !sns.data.sns_token)
		throw new Error("Dingtalk sns_token not found.")

	response.sns_token = sns.data.sns_token

	userInfo = HTTP.get "https://oapi.dingtalk.com/sns/getuserinfo",
		params: 
			sns_token: sns.data.sns_token
		
	console.log(userInfo.data)

	if (!userInfo.data || !userInfo.data.user_info)
		throw new Error("Dingtalk user_info not found.")

	response.user_info = userInfo.data.user_info;

	return response


Dingtalk.retrieveCredential = (credentialToken, credentialSecret) ->
	return OAuth.retrieveCredential(credentialToken, credentialSecret);



OAuth.registerService 'dingtalk', 2, null, (query) ->
	console.log(query);
	response = Dingtalk.getTokenResponse(query);
	console.log(response);

	return {
		serviceData:
			id: response.user_info.dingId,
			sns_token: response.sns_token,
			openid: response.openid,
			unionid: response.unionid,
		options:
			profile: 
				name: response.user_info.nick
	}
	