Template.cms_home.helpers
    cms_sites: ()->
        return db.cms_sites.find()
    cms_categories: ()->
        siteId = Session.get("siteId")
        if siteId
            return db.cms_categories.find({site: siteId})
    cms_posts: ()->
        return db.cms_posts.find()

Template.cms_home.events
    "click .navigation": (e, t)->
        a = $(e.target).closest('a');
        router = a[0]?.dataset["router"]
        if router
            NavigationController.go router