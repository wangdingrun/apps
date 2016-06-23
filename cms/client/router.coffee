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
		BlazeLayout.render 'masterLayout',
			main: "cms_site_home"

FlowRouter.route '/cms/:siteId/p/:postId',
	action: (params, queryParams)->
		if params.siteId != Session.get("siteId")
			Session.set("siteId", params.siteId)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_post"

FlowRouter.route '/cms/:siteId/t/:tag',
	action: (params, queryParams)->
		if params.siteId != Session.get("siteId")
			Session.set("siteId", params.siteId)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_tagged"

FlowRouter.route '/cms/:siteId/t/:tag/p/:postId',
	action: (params, queryParams)->
		if params.siteId != Session.get("siteId")
			Session.set("siteId", params.siteId)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_post"

FlowRouter.route '/cms/:siteId/o/:organizationId',
	action: (params, queryParams)->
		if params.siteId != Session.get("siteId")
			Session.set("siteId", params.siteId)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_organization"
			
FlowRouter.route '/cms/:siteId/o/:organizationId/p/:postId',
	action: (params, queryParams)->
		if params.siteId != Session.get("siteId")
			Session.set("siteId", params.siteId)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_post"