Template.cms_home.helpers
    cms_sites: ()->
        return db.cms_sites.find().fetch()

Template.cms_home.events
    "click .navigation": (e, t)->
        a = $(e.target).closest('a');
        router = a[0]?.dataset["router"]
        if router
            NavigationController.go router