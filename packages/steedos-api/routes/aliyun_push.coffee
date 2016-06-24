ALY = Npm.require('aliyun-sdk');

Aliyun_push = {};

console.log("loading Aliyun_push...")

Aliyun_push.sendMessage = (userTokens, notification) ->
    ALYPUSH = new (ALY.PUSH)(
        accessKeyId: 'W5zVsIhQtVPlh8vx'
        secretAccessKey: 'M1HRVLDQl4deLoCf0cwOOABzb77Agv'
        endpoint: 'http://cloudpush.aliyuncs.com'
        apiVersion: '2015-08-27');
    
    ALYPUSH.pushNoticeToAndroid
        AppKey: '23390511'
        Target: 'device'
        TargetValue: userTokens.toString()
        Title: notification.title
        Summary: notification.text
        , (err, res) ->
            console.log err,res

console.log "Aliyun_push update Push.sendGCM...."
console.log Push
console.log "Push.sendGCM" 
console.log Push.sendGCM
console.log "Aliyun_push.Configure"


Meteor.startup ->
    Push.Configure
        debug: true
        apn:
                keyData: 'xxx' #Assets.getText('push/apns-key-workflow.pem')
                certData: 'xxx' #Assets.getText('push/apns-cert-workflow.pem')
        gcm:
                apiKey: "xxx"
        baidu:
                apiKey: "sDfG6F30DnSW0KjNDdGREqcY"
                secret: "uOyudjcjUMBae9zb823eLhINFHQtnTFC"
        keepNotifications: true
        sendInterval: 1000
        sendBatchSize: 10
        production: true
        
    console.log 'Aliyun_push.Configure'
    console.log "Push.sendGCM" 
    console.log Push.sendGCM
    if Push and typeof Push.sendGCM == 'function'
        
        console.log "Aliyun_push add Push.sendAliyun...."

        Push.old_sendGCM = Push.sendGCM;

        Push.sendAliyun = (userTokens, notification) ->

            console.log 'sendAliyun', userTokens, notification

            if Match.test(notification.gcm, Object)
                notification = _.extend({}, notification, notification.gcm)
            # Make sure userTokens are an array of strings
            if userTokens == '' + userTokens
                userTokens = [ userTokens ]
            # Check if any tokens in there to send
            if !userTokens.length
                if Push.debug
                    console.log 'sendGCM no push tokens found'
                return
            if Push.debug
                console.log 'sendAliyun', userTokens, notification

            

            

            gcm = Npm.require('node-gcm')
            Fiber = Npm.require('fibers')
            # Allow user to set payload
            data = if notification.payload then ejson: EJSON.stringify(notification.payload) else {}

            data.title = notification.title
            
            data.message = notification.text
            
            # Set image
            if typeof notification.image != 'undefined'
                data.image = notification.image
            # Set extra details
            if typeof notification.badge != 'undefined'
                data.msgcnt = notification.badge
            if typeof notification.sound != 'undefined'
                data.soundname = notification.sound
            if typeof notification.notId != 'undefined'
                data.notId = notification.notId

            message = new (gcm.Message)(
                collapseKey: notification.from
                data: data)

            if Push.debug
                console.log 'Create GCM Sender using "' + options.gcm.apiKey + '"'

            sender = new (gcm.Sender)(options.gcm.apiKey)
            _.each userTokens, (value) ->
                if Push.debug
                    console.log 'A:Send message to: ' + value
      
            userToken = if userTokens.length == 1 then userTokens[0] else null
            sender.send message, userTokens, 5, (err, result) ->
                if err
                    if Push.debug
                        console.log 'ANDROID ERROR: result of sender: ' + result
                else
                    if result == null
                        if Push.debug
                            console.log 'ANDROID: Result of sender is null'
                    return

            if Push.debug
                console.log 'ANDROID: Result of sender: ' + JSON.stringify(result)

            if result.canonical_ids == 1 and userToken
                Fiber((self) ->
                    try
                        self.callback self.oldToken, self.newToken
                    catch err
                ).run
                    oldToken: gcm: userToken
                    newToken: gcm: result.results[0].registration_id
                    callback: _replaceToken
            if result.failure != 0 and userToken
                Fiber((self) ->
                    try
                        self.callback self.token
                    catch err
                ).run
                    token: gcm: userToken
                    callback: _removeToken



        Push.sendGCM = (userTokens, notification) ->
            console.log 'sendGCM from aliyun-> Push.sendGCM'
            if Match.test(notification.gcm, Object)
                notification = _.extend({}, notification, notification.gcm)
            # Make sure userTokens are an array of strings
            if userTokens == '' + userTokens
                userTokens = [ userTokens ]
            # Check if any tokens in there to send
            if !userTokens.length
                if Push.debug
                    console.log 'sendGCM no push tokens found'
                return
            if Push.debug
                console.log 'sendGCM', userTokens, notification

            aliyunTokens = userTokens.filter((item) ->
                                item.indexOf('aliyun:') > -1
                            )

            console.log 'aliyunTokens is ', aliyunTokens.toString()

            gcmTokens = userTokens.filter((item) ->
                                item.indexOf("aliyun:") < 0
                            )

            console.log 'gcmTokens is ' , gcmTokens.toString();

            Push.sendAliyun(aliyunTokens, notification);

            Push.old_sendGCM(gcmTokens, notification);
