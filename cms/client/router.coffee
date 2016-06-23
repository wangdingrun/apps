FlowRouter.route '/cms',
	action: (params, queryParams)->
		Session.set("postId", null)
		Session.set("tag", null)
		Session.set("siteId", null)
		BlazeLayout.render 'masterLayout',
			main: "cms_home"

FlowRouter.route '/cms/:siteId/admin',
	action: (params, queryParams)->
		Session.set("siteId", params.siteId)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_admin"

FlowRouter.route '/cms/:siteId',
	action: (params, queryParams)->
		Session.set("siteId", params.siteId)
		Session.set("siteCategory", null)
		Session.set("siteTag", null)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_home"

FlowRouter.route '/cms/:siteId/p/:postId',
	action: (params, queryParams)->
		Session.set("siteId", params.siteId)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_post"

FlowRouter.route '/cms/:siteId/t/:siteTag',
	action: (params, queryParams)->
		Session.set("siteId", params.siteId)
		Session.set("siteTag", params.siteTag)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_tagged"

FlowRouter.route '/cms/:siteId/t/:siteTag/p/:postId',
	action: (params, queryParams)->
		Session.set("siteId", params.siteId)
		Session.set("siteTag", params.siteTag)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_post"

FlowRouter.route '/cms/:siteId/c/:siteCategory',
	action: (params, queryParams)->
		Session.set("siteId", params.siteId)
		Session.set("siteCategory", params.siteCategory)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_category"
			
FlowRouter.route '/cms/:siteId/c/:siteCategory/p/:postId',
	action: (params, queryParams)->
		Session.set("siteId", params.siteId)
		Session.set("siteCategory", params.siteCategory)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_post"