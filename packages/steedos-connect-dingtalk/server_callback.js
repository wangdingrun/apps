var WXBizMsgCrypt = Npm.require('wechat-crypto');
//钉钉文档：http://ddtalk.github.io/dingTalkDoc/?spm=a3140.7785475.0.0.p5bAUd#2-回调接口（分为五个回调类型）

var config = {
  token: "steedos",
  encodingAESKey: "vr8r85bhgaruo482zilcyf6uezqwpxpf88w77t70dow",
  suiteKey: "suitedjcpb8olmececers"
}

//suite4xxxxxxxxxxxxxxx 是钉钉默认测试suiteid 
var newCrypt = new WXBizMsgCrypt(config.token, config.encodingAESKey, config.suiteKey || 'suite4xxxxxxxxxxxxxxx');
var TICKET_EXPIRES_IN = config.ticket_expires_in || 1000 * 60 * 20 //20分钟

JsonRoutes.add("post", "/api/dingtalk/callback", function (req, res, next) {

  console.log(req.query);
  console.log(req.body);
  var signature = req.query.signature;
  var timestamp = req.query.timestamp;
  var nonce = req.query.nonce;
  var encrypt = req.body.encrypt;

  if (signature !== newCrypt.getSignature(timestamp, nonce, encrypt)) {
    res.writeHead(401);
    res.end('Invalid signature');
    return;
  }

  var result = newCrypt.decrypt(encrypt);
  var message = JSON.parse(result.message);
  if (message.EventType === 'check_update_suite_url' || message.EventType === 'check_create_suite_url') { //创建套件第一步，验证有效性。
    var Random = message.Random;
    result = Dingtalk._jsonWrapper(timestamp, nonce, Random);
    JsonRoutes.sendResult(res, {
      data: result
    });

  } else {
    res.reply = function() { //返回加密后的success
      result = Dingtalk._jsonWrapper(timestamp, nonce, 'success');
      JsonRoutes.sendResult(res, {
        data: result
      });
    }

    if (message.EventType === 'suite_ticket') {
      // var data = {
      //   value: message.SuiteTicket,
      //   expires: Number(message.TimeStamp) + TICKET_EXPIRES_IN
      // }
      // config.saveTicket(data, function(err) {
      //   if (err) {
      //     return next(err);
      //   } else {
      //     res.reply();
      //   }
      // });
      console.log('EventType is suite_ticket');
      var o = ServiceConfiguration.configurations.findOne({service: "dingtalk"});
      if (o) {
        r = Dingtalk.suiteAccessTokenGet(o.suite_key, o.suite_secret, message.SuiteTicket);
        console.log(r);
        if (r && r.suite_access_token) {
          ServiceConfiguration.configurations.update(o._id, {$set: {"suite_ticket": message.SuiteTicket, "suite_access_token": r.suite_access_token}});
        }

      }


      res.reply();
    }else{
      Dingtalk.processCallback(message, req, res, next);
    }

    // 回调向ISV推送临时授权码
    if (message.EventType === 'tmp_auth_code') {
      var tmp_auth_code = message.AuthCode;
      // var suiteKey = message.SuiteKey;
      var o = ServiceConfiguration.configurations.findOne({service: "dingtalk"});
      if (o && o.suite_access_token) {

        r = Dingtalk.permanentCodeGet(o.suite_access_token, tmp_auth_code);
        if (r && r.permanent_code) {

          // 同步
          var permanent_code = r.permanent_code;
          var auth_corp_info = r.auth_corp_info;

          var at = Dingtalk.corpTokenGet(o.suite_access_token, auth_corp_info.corpid, permanent_code);
          if (at && at.access_token) {
            Dingtalk.syncCompany(at.access_token, auth_corp_info, permanent_code);
          }

          // 激活授权套件
          Dingtalk.activateSuitePost(o.suite_access_token, o.suite_key, auth_corp_info.corpid, permanent_code);
        }

      }

      res.reply();
    }

  };
});

Dingtalk.processCallback = function(message, req, res, next) {
    console.log('message', message);

    res.reply();
}

Dingtalk._jsonWrapper = function(timestamp, nonce, text) {
  var encrypt = newCrypt.encrypt(text);
  var msg_signature = newCrypt.getSignature(timestamp, nonce, encrypt); //新签名
  return {
    msg_signature: msg_signature,
    encrypt: encrypt,
    timeStamp: timestamp,
    nonce: nonce
  };
}
