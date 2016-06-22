Template.cms_site_admin.helpers
    cms_sites: ()->
        return db.cms_sites.find()

Template.cms_site_admin.events
    "click .navigation": (e, t)->
        a = $(e.target).closest('a');
        router = a[0]?.dataset["router"]
        if router
            NavigationController.go router