FlowRouter.route '/cms',
    action: (params, queryParams)->
        BlazeLayout.render 'masterLayout',
            main: "cms_home"

FlowRouter.route '/cms/site/:siteId',
    action: (params, queryParams)->
        Session.set("siteId", params.siteId)
        BlazeLayout.render 'masterLayout',
            main: "cms_site_home"

FlowRouter.route '/cms/site/:siteId/post/:postId',
    action: (params, queryParams)->
        if params.siteId != Session.get("siteId")
            Session.set("siteId", params.siteId)
        BlazeLayout.render 'masterLayout',
            main: "cms_post_home"