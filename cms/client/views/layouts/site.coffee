Template.siteLayout.onCreated ->
	

Template.siteLayout.onRendered ->


Template.siteLayout.helpers 
    cms_site: ()->
        siteId = FlowRouter.current().params.siteId
        if siteId
            return db.cms_sites.findOne(siteId)
    cms_categories: ()->
        siteId = FlowRouter.current().params.siteId
        if siteId
            return db.cms_categories.find({site:siteId})
    category_is_current: (categoryId)->
    	return categoryId == Session.get("categoryId")

Template.siteLayout.events
	