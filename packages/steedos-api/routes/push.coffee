JsonRoutes.add "post", "/api/push/message", (req, res, next) ->
        Push.send
                from: 'steedos',
                title: 'Hello',
                text: 'world',
                badge: 999,
                query: 


Meteor.methods
        Meteor.methods
                userNotification: (text,title,userId) ->
                        var badge = 1
                        Push.send
                            from: 'steedos',
                            title: title,
                            text: text,
                            badge: badge,
                            payload:
                                title: title,
                            query:
                                userId: userId #this will send to a specific Meteor.user()._id
                            
               