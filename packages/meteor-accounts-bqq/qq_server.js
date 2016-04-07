Qq = {};

OAuth.registerService('bqq', 2, null, function(query) {

  var response = getTokenResponse(query);
  return {
    serviceData: {
      id: response.openId,
      accessToken: response.accessToken,
      nickname: response.userInfo.nickname
    },
    options: {
      profile: { name: response.userInfo.nickname },
    }
  };
});

var getTokenResponse = function (query) {
  var config = ServiceConfiguration.configurations.findOne({service: 'bqq'});

  if (!config)
    throw new ServiceConfiguration.ConfigError();

  var response;
  try {
    response = HTTP.get(
      "https://openapi.b.qq.com/oauth2/token", {
        params: {
          code: query.code,
          client_id: config.clientId,
          redirect_uri: OAuth._redirectUri("bqq", config),
          client_secret: OAuth.openSecret(config.secret),
          grant_type: 'authorization_code'
        }
      });

    if (response.error) // if the http response was an error
        throw response.error;
    if (typeof response.content === "string")
        var qqAccessToken;
        _.each(response.content.split('&'), function (kvString) {
          var kvArray = kvString.split('=');
          if (kvArray[0] === 'access_token')
            qqAccessToken = kvArray[1];
        });
    if (response.content.error)
        throw response.content;
  } catch (err) {
    throw _.extend(new Error("Failed to complete OAuth handshake with QQ. " + err.message),
                   {response: err.response});
  }

  try {
    response = HTTP.get(
      "https://openapi.b.qq.com/oauth2/me", {
        params: {
          access_token: qqAccessToken
        }
      });

    if (response.error) // if the http response was an error
        throw response.error;
    if (typeof response.content === "string")
        // The response content in /me requires trickly JSONP callback to parse
        var meContent = {};
        var callbackExp = /^\s*callback\s*\((.+)\)\s*;\s*$/;
        var matched = response.content.match(callbackExp);
        if (matched && matched.length === 2) {
          meContent = JSON.parse(matched[1]);
          if (meContent.error) {
            console.log("Error in getting account's open id, details: " + meContent.error);
            throw new Error(meContent.error);
          }
        } else {
          throw new Error("Error in getting account's open id");
        }

    if (response.content.error)
        throw response.content;
  } catch (err) {
    throw _.extend(new Error("Failed to complete OAuth handshake with QQ. " + err.message),
                   {response: err.response});
  }

  return {
    accessToken: qqAccessToken,
    openId: meContent.openid,
    userInfo: userInfoContent
  }

};

Qq.retrieveCredential = function(credentialToken, credentialSecret) {
  return OAuth.retrieveCredential(credentialToken, credentialSecret);
};
