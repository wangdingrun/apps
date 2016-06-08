loginWithCookie = (onSuccess) ->
    userId = getCookie("X-User-Id")
    authToken = getCookie("X-Auth-Token")
    if userId and authToken
        if Meteor.userId() != userId
            Accounts.connection.setUserId(userId);
            Accounts.loginWithToken authToken,  (err) ->
                if (err) 
                    Meteor._debug("Error logging in with token: " + err);
                    Accounts.makeClientLoggedOut();
                else if onSuccess
                    onSuccess();

getCookie = (name)->
    pattern = RegExp(name + "=.[^;]*")
    matched = document.cookie.match(pattern)
    if(matched)
        cookie = matched[0].split('=')
        return cookie[1]
    return false


Meteor.startup ->
    if (!Accounts._storedUserId())
        loginWithCookie ()->
            Meteor._debug("cookie login success");