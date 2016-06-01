Meteor.startup ->
  Steedos.settings.webservices = Meteor.settings.public.webservices

  if !Steedos.settings.webservices
    Steedos.settings.webservices =
      uuflow: 
        status: "active",
        url: "/"
      www: 
        status: "active",
        url: "/"
      s3: 
        status: "active",
        url: "/"
      chat:
        status: "active",
        url: "/chat/"
      workflow:
        status: "active",
        url: "/workflow/"
      admin: 
        status: "active",
        url: "/"
      push: 
        status: "active",
        url: "/pu/"
      keyvalue: 
        status: "active",
        url: "/"
      account: 
        status: "active",
        url: "/"
      contacts: 
        status: "active",
        url: "/"


if Meteor.isServer

  Meteor.startup ->

    Steedos.settings.oauth = 
      bqq: 
        clientId: "200626779",
        secret: "UkQ6G6gFJwJBfYuv",
        scope: "get_user_info"
      dingtalk: 
        clientId: "dingoa7enhp5nfiip75vmk",
        secret: "NAlKUjGGWrffcAss9nMSd68DTUggYhg559HQT7kpACDcyu7g1PpUdBcXAOlBWZtX",
        scope: "snsapi_login"


    _.each Steedos.settings.oauth, (v, k)->

      o = ServiceConfiguration.configurations.findOne
            service: k

      if o
        ServiceConfiguration.configurations.update o._id, $set: 
          clientId: v.clientId,
          scope: v.scope,
          secret: v.secret
      else
        ServiceConfiguration.configurations.insert
          service: k,
          clientId: v.clientId,
          scope: v.scope,
          secret: v.secret
