FlowRouter.route '/cms',
    action: (params, queryParams)->
        BlazeLayout.render 'masterLayout',
            main: "cms_home"

FlowRouter.route '/cms/admin',
    action: (params, queryParams)->
        BlazeLayout.render 'masterLayout',
            main: "cms_admin"

FlowRouter.route '/cms/site/:siteId',
    action: (params, queryParams)->
        Session.set("siteId", params.siteId)
        BlazeLayout.render 'siteLayout',
            main: "cms_site_home"

FlowRouter.route '/cms/site/:siteId/admin',
    action: (params, queryParams)->
        Session.set("siteId", params.siteId)
        BlazeLayout.render 'siteLayout',
            main: "cms_admin"

FlowRouter.route '/cms/site/:siteId/category/:categoryId',
    action: (params, queryParams)->
        if params.siteId != Session.get("siteId")
            Session.set("siteId", params.siteId)
        if params.categoryId != Session.get("categoryId")
            Session.set("categoryId", params.categoryId)
        BlazeLayout.render 'siteLayout',
            main: "cms_site_category"

FlowRouter.route '/cms/site/:siteId/post/:postId',
    action: (params, queryParams)->
        if params.siteId != Session.get("siteId")
            Session.set("siteId", params.siteId)
        BlazeLayout.render 'siteLayout',
            main: "cms_site_post"