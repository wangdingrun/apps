Template.cms_post_home.helpers
    cms_site: ()->
        siteId = Session.get("siteId")
        if siteId
            return db.cms_sites.findOne(siteId)
    cms_post: ()->
        postId = FlowRouter.current().params.postId
        return db.cms_posts.findOne({_id: postId})
    cms_posts: ()->
        postId = FlowRouter.current().params.postId
        return db.cms_posts.find({_id: postId})

Template.cms_post_home.events
    "click .navigation": (e, t)->
        a = $(e.target).closest('a');
        router = a[0]?.dataset["router"]
        if router
            NavigationController.go router