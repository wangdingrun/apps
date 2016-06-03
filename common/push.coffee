if Meteor.isCordova
        Meteor.startup ->
                Push.Configure
                        android:
                                senderID: window.ANDROID_SENDER_ID
                                sound: true
                                vibrate: true
                        ios:
                                badge: true
                                clearBadge: true
                                sound: true
                                alert: true
                        appName: "workflow"


if Meteor.isServer
        Meteor.startup ->
                Push.Configure
                        debug: true
                        apn:
                                keyData: Assets.getText('push/apns-key-workflow.pem')
                                certData: Assets.getText('push/apns-cert-workflow.pem')
                        gcm:
                                apiKey: "xxx"
                        baidu:
                                apiKey: "sDfG6F30DnSW0KjNDdGREqcY"
                                secret: "uOyudjcjUMBae9zb823eLhINFHQtnTFC"
                        keepNotifications: true
                        sendInterval: 1000
                        sendBatchSize: 10
                        production: true