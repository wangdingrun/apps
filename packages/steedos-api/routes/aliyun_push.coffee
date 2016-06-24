ALY = Npm.require('aliyun-sdk');

aliyun_push = {};

aliyun_push.sendMessage : (userTokens, notification)->
    ALYPUSH = new (ALY.PUSH)(
          accessKeyId: 'W5zVsIhQtVPlh8vx'
          secretAccessKey: 'M1HRVLDQl4deLoCf0cwOOABzb77Agv'
          endpoint: 'http://cloudpush.aliyuncs.com'
          apiVersion: '2015-08-27');
    
    ALYPUSH.pushNoticeToAndroid
            AppKey: '23390511'
            Target: 'all'
            TargetValue: 'all'
            Title: title
            Summary: summary
            , (err, res) ->
                console.log err res


if Push and typeof Push.sendGCM == 'function'

    Push.old_sendGCM = Push.sendGCM;

    Push.sendAliyun : -> (userTokens, notification) ->

        console.log 'sendAliyun' userTokens, notification

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



    Push.sendGCM: (userTokens, notification) ->
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

        gcmTokens = userTokens.filter((item) ->
                            item.indexOf("aliyun:") < 0
                        )

        Push.sendAliyun(aliyunTokens, notification);

        Push.old_sendGCM(gcmTokens, notification);
