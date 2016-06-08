loginWithCookie = (onSuccess) ->
    userId = Cookies.get("X-User-Id")
    authToken = Cookies.get("X-Auth-Token")
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