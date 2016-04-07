if (Meteor.isServer) {

  ServiceConfiguration.configurations.remove({
    service: "bqq"
  });
  ServiceConfiguration.configurations.insert({
    service: "bqq",
    clientId: "xxx",
    scope:'get_user_info',
    secret: "xxx"
  });
  	
}