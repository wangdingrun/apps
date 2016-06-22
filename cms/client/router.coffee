FlowRouter.route '/cms',
	action: (params, queryParams)->
		Session.set("postId", null)
		Session.set("tag", null)
		Session.set("siteId", null)
		BlazeLayout.render 'masterLayout',
			main: "cms_theme_default"

FlowRouter.route '/cms/admin',
	action: (params, queryParams)->
		BlazeLayout.render 'masterLayout',
			main: "cms_admin"

FlowRouter.route '/cms/site/:siteId',
	action: (params, queryParams)->
		Session.set("postId", null)
		Session.set("tag", null)
		Session.set("siteId", params.siteId)
		BlazeLayout.render 'masterLayout',
			main: "cms_theme_default"

FlowRouter.route '/cms/site/:siteId/admin',
	action: (params, queryParams)->
		Session.set("siteId", params.siteId)
		BlazeLayout.render 'masterLayout',
			main: "cms_admin"

FlowRouter.route '/cms/site/:siteId/t/:tag',
	action: (params, queryParams)->
		Session.set("postId", null)
		if params.siteId != Session.get("siteId")
			Session.set("siteId", params.siteId)
		if params.tag != Session.get("tag")
			Session.set("tag", params.tag)
		BlazeLayout.render 'masterLayout',
			main: "cms_theme_default"

FlowRouter.route '/cms/p/:postId',
	action: (params, queryParams)->
		Session.set("tag", null)
		Session.set("siteId", null)
		if params.postId != Session.get("postId")
			Session.set("postId", params.postId)
		BlazeLayout.render 'masterLayout',
			main: "cms_theme_default"
			
FlowRouter.route '/cms/site/:siteId/p/:postId',
	action: (params, queryParams)->
		Session.set("tag", null)
		if params.siteId != Session.get("siteId")
			Session.set("siteId", params.siteId)
		if params.postId != Session.get("postId")
			Session.set("postId", params.postId)
		BlazeLayout.render 'masterLayout',
			main: "cms_theme_default"

FlowRouter.route '/cms/site/:siteId/t/:tag/p/:postId',
	action: (params, queryParams)->
		if params.siteId != Session.get("siteId")
			Session.set("siteId", params.siteId)
		if params.tag != Session.get("tag")
			Session.set("tag", params.tag)
		if params.postId != Session.get("postId")
			Session.set("postId", params.postId)
		BlazeLayout.render 'masterLayout',
			main: "cms_theme_default"