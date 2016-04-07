Qq = {};

OAuth.registerService('bqq', 2, null, function(query) {

  var response = getTokenResponse(query);
  return {
    serviceData: {
      id: response.open_id,
      accessToken: response.access_token
    }
  };
});

var getTokenResponse = function (query) {
  var config = ServiceConfiguration.configurations.findOne({service: 'bqq'});

  if (!config)
    throw new ServiceConfiguration.ConfigError();

  var tokenResponse;
  try {
    tokenResponse = HTTP.get(
      "https://openapi.b.qq.com/oauth2/token", {
        params: {
          code: query.code,
          app_id: config.clientId,
          redirect_uri: OAuth._redirectUri("bqq", config),
          app_secret: OAuth.openSecret(config.secret),
          grant_type: 'authorization_code'
        }
      });
    
    if (tokenResponse.data.ret) // if the http response was an error
        throw tokenResponse.data.msg;
  } catch (err) {
    throw _.extend(new Error("Failed to complete OAuth handshake with QQ. " + err.message),
                   {response: err.response});
  }


  return tokenResponse.data.data

};

Qq.retrieveCredential = function(credentialToken, credentialSecret) {
  return OAuth.retrieveCredential(credentialToken, credentialSecret);
};
