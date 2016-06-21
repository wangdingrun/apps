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
    "click .navigation": (e, t)->
        a = $(e.target).closest('a');
        router = a[0]?.dataset["router"]
        if router
            NavigationController.go router