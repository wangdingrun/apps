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

    Steedos.getSpaceApps = ()->
        selector = {}
        if Steedos.getSpaceId()
            space = db.spaces.findOne(Steedos.getSpaceId())
            if space?.apps_enabled?.length>0
                selector._id = {$in: space.apps_enabled}
        if Steedos.isMobile()
            selector.mobile = true
        return db.apps.find(selector, {sort: {sort: 1, space_sort: 1}});

    Steedos.getLocale = ()->
        if Meteor.user()?.locale
            locale = Meteor.user().locale
        else
            l = window.navigator.userLanguage || window.navigator.language || 'en'
            if l.indexOf("zh") >=0
                locale = "zh-cn"
            else
                locale = "en-us"

   
    Steedos.getBadge = (spaceId)->
        badge = 0
        if spaceId
            space_user = db.space_users.findOne({user: Meteor.userId(), space: spaceId}, {fields: {apps: 1}})
            b = space_user?.apps?.workflow?.badge 
            if b
                badge = b 
        else
            space_users = db.space_users.find({user: Meteor.userId()}, {fields: {apps: 1}})
            space_users.forEach (su)->
                b = su.apps?.workflow?.badge
                if b
                    badge += b
        return badge

