Template.cms_site_home.helpers
    cms_site: ()->
        siteId = Session.get("siteId")
        if siteId
            return db.cms_sites.findOne(siteId)
    cms_categories: ()->
        siteId = Session.get("siteId")
        if siteId
            return db.cms_categories.find({site: siteId})
    cms_posts: ()->
        siteId = Session.get("siteId")
        return db.cms_posts.find({site:siteId})

Template.cms_site_home.events