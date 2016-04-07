JsonRoutes.add("get", "/api/bqq/companyToken", function (req, res, next) {
  var config = ServiceConfiguration.configurations.findOne({service: 'bqq'});
  var response;
  console.log("companyToken")
  console.log(req.query)
  try {
    response = HTTP.get(
      "https://openapi.b.qq.com/oauth2/companyToken", {
        params: {
          code: req.query.code,
          client_id: config.clientId,
          redirect_uri: "http://hotlong.vicp.net/api/bqq/companyToken",
          client_secret: OAuth.openSecret(config.secret),
          grant_type: 'authorization_code'
        }
      });

    if (response.error_code) // if the http response was an error
        throw response.msg;
    
  } catch (err) {
    throw _.extend(new Error("Failed to complete OAuth handshake with QQ. " + err.message),
                   {response: err.response});
  }


  JsonRoutes.sendResult(res, {
    data: {
      ret: 0,
      msg: "成功",
      token: response.data
    }
  });
});