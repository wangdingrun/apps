JsonRoutes.add "post", "/api/setup/validate", (req, res, next) ->

  JsonRoutes.sendResult res, 
    code: 401,
    data: 
      "error": "Validate Request -- Missing X-STEEDOS-WEBAUTH-TOKEN cookie", 
      "instance": "1329598861", 
      "success": false
