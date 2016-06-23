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
		Session.set("siteCategoryId", null)
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

FlowRouter.route '/cms/:siteId/c/:siteCategoryId',
	action: (params, queryParams)->
		Session.set("siteId", params.siteId)
		Session.set("siteCategoryId", params.siteCategoryId)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_category"
			
FlowRouter.route '/cms/:siteId/c/:siteCategoryId/p/:postId',
	action: (params, queryParams)->
		Session.set("siteId", params.siteId)
		Session.set("siteCategoryId", params.siteCategoryId)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_post"