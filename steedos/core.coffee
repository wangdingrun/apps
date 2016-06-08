if Meteor.isClient
    Steedos.setSpaceId = (spaceId)->
        if spaceId != Session.get("spaceId")
            Session.set("spaceId", spaceId)     
            localStorage.setItem("spaceId:" + Meteor.userId(), spaceId);

    Steedos.getSpaceId = ()->

        spaceId = Session.get("spaceId")
        if spaceId
            return spaceId

        spaceId = localStorage.getItem("spaceId:" + Meteor.userId())
        if spaceId
            return spaceId
        else
            return undefined;

    Steedos.getLocale = ()->
        if Meteor.user()?.locale
            locale = Meteor.user().locale
        else
            l = window.navigator.userLanguage || window.navigator.language || 'en'
            if l.indexOf("zh") >=0
                locale = "zh-cn"
            else
                locale = "en-us"

