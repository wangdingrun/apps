loginWithCookie = (onSuccess) ->
    cookie = new Cookies()
    userId = cookie["X-User-Id"]
    authToken = cookie["X-Auth-Token"]
    if userId and authToken
        if Meteor.userId() != userId
            Accounts.connection.setUserId(userId);
            Accounts.loginWithToken authToken,  (err) ->
                if (err) 
                    Meteor._debug("Error logging in with token: " + err);
                    Accounts.makeClientLoggedOut();
                else if onSuccess
                    onSuccess();


Meteor.startup ->
    if (!Accounts._storedUserId())
        loginWithCookie ()->
            Meteor._debug("cookie login success");