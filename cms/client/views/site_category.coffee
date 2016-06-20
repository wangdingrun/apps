Template.cms_site_category.helpers
    cms_site: ()->
        siteId = Session.get("siteId")
        if siteId
            return db.cms_sites.findOne(siteId)
    cms_posts: ()->
        categoryId = Session.get("categoryId")
        return db.cms_posts.find({category:categoryId})

Template.cms_site_category.events