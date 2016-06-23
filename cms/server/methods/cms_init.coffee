Meteor.methods
    cms_init: (spaceId)->
        if !spaceId 
            return false;
        space = db.spaces.findOne(spaceId)
        if !space 
            return false;
        site = db.cms_sites.findOne({space: spaceId})
        if site
            return false;

        siteId = db.cms_sites.insert
            space: spaceId
            name: space.name
            owner: space.owner

        return siteId