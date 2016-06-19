Template.cms_home.events
    "click .navigation": (e, t)->
        a = $(e.target).closest('a');
        router = a[0]?.dataset["router"]
        if router
            NavigationController.go router