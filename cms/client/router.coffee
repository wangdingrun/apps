FlowRouter.route '/cms',
	action: (params, queryParams)->
		Session.set("postId", null)
		Session.set("tag", null)
		Session.set("siteId", null)
		BlazeLayout.render 'masterLayout',
			main: "cms_home"

FlowRouter.route '/cms/:siteId',
	action: (params, queryParams)->
		Session.set("postId", null)
		Session.set("tag", null)
		Session.set("cms_organization_id", null)
		Session.set("siteId", params.siteId)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_home"

FlowRouter.route '/cms/:siteId/admin',
	action: (params, queryParams)->
		Session.set("siteId", params.siteId)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_admin"

FlowRouter.route '/cms/:siteId/t/:tag',
	action: (params, queryParams)->
		Session.set("postId", null)
		if params.siteId != Session.get("siteId")
			Session.set("siteId", params.siteId)
		if params.tag != Session.get("tag")
			Session.set("tag", params.tag)
		Session.set("cms_organization_id", null)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_tagged"

FlowRouter.route '/cms/:siteId/o/:cms_organization_id',
	action: (params, queryParams)->
		Session.set("postId", null)
		if params.siteId != Session.get("siteId")
			Session.set("siteId", params.siteId)
		if params.cms_organization_id != Session.get("cms_organization_id")
			Session.set("cms_organization_id", params.cms_organization_id)
		Session.set("tag", null)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_organization"

FlowRouter.route '/cms/:siteId/p/:postId',
	action: (params, queryParams)->
		if params.siteId != Session.get("siteId")
			Session.set("siteId", params.siteId)
		Session.set("tag", null)
		if params.postId != Session.get("postId")
			Session.set("postId", params.postId)
		BlazeLayout.render 'masterLayout',
			main: "cms_site_post"
			
FlowRouter.route '/cms/:siteId/p/:postId',
	action: (params, queryParams)->
		Session.set("tag", null)
		if params.siteId != Session.get("siteId")
			Session.set("siteId", params.siteId)
		if params.postId != Session.get("postId")
			Session.set("postId", params.postId)
		BlazeLayout.render 'masterLayout',
			main: "cms_theme_default"

FlowRouter.route '/cms/:siteId/t/:tag/p/:postId',
	action: (params, queryParams)->
		if params.siteId != Session.get("siteId")
			Session.set("siteId", params.siteId)
		if params.tag != Session.get("tag")
			Session.set("tag", params.tag)
		if params.postId != Session.get("postId")
			Session.set("postId", params.postId)
		BlazeLayout.render 'masterLayout',
			main: "cms_theme_default"