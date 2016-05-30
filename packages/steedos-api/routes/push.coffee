JsonRoutes.add "post", "/api/push/message", (req, res, next) ->
        Push.send
                from: 'push',
                title: 'Hello',
                text: 'world',
                badge: 999,
                # query: 
                #    userId: 'xxxxxxxxx'