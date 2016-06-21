Template.site_home.helpers
    site: ()->
        siteId = this.params.siteId
        if siteId
            return db.cms_sites.findOne(siteId)
    category: ()->
        siteId = this.params.categoryId
        if siteId
            return db.cms_categories.find({site: siteId})
    posts: ()->
        siteId = this.params.siteId
        return db.cms_posts.find({site:siteId})
