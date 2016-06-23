Template.cms_home.helpers
    cms_sites: ()->
        return db.cms_sites.find()

Template.cms_home.onRendered ->
    siteCount = db.cms_sites.find().count();
    if siteCount == 0
        Meteor.call "cms_init", Session.get("spaceId"), (error, result) ->
            if result
                FlowRouter.go "/cms/" + result;
    else if siteCount == 1
        site = db.cms_sites.findOne()
        FlowRouter.go "/cms/" + site._id;
