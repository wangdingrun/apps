Template.cms_site_post.helpers
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

Template.cms_site_post.events