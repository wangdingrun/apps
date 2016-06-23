Template.registerHelpers = (dict) ->
	_.each dict, (v, k)->
		Template.registerHelper k, v


Template.registerHelpers

	CategoryId: ()->
		return Template.instance().data.params.categoryId

	CategoryActive: (c)->
		categoryId = Template.instance().data.params.categoryId
		if categoryId == c
			return "active"

	Category: ()->
		categoryId = Template.instance().data.params.categoryId
		if categoryId
			return db.cms_categories.findOne(categoryId)

	ParentCategory: ()->
		categoryId = Template.instance().data.params.categoryId
		if categoryId
			c = db.cms_categories.findOne(categoryId)
			if c?.parent
				return db.cms_categories.findOne(c.parent)

	SubCategories: (parent)->
		if parent == "root"
			siteId = Template.instance().data.params.siteId
			return db.cms_categories.find({site: siteId, parent: null})
		else
			return db.cms_categories.find({parent: parent})
			
	SubCategoriesCount: (parent)->
		return db.cms_categories.find({parent: parent}).count()



Template.registerHelper 'Title', ->
	siteId = Template.instance().data.params.siteId
	site = db.cms_sites.findOne({_id: siteId}, {fields: {name: 1}})

	return site?.name

Template.registerHelper 'Posts', (categoryId, limit, skip)->
	if !limit 
		limit = 5
	skip = 0
	siteId = Template.instance().data.params.siteId
	if siteId and categoryId
		return db.cms_posts.find({site: siteId, category: categoryId}, {sort: {posted: -1}, limit: limit, skip: skip})
	else if siteId
		return db.cms_posts.find({site: siteId}, {sort: {posted: -1}, limit: limit, skip: skip})

Template.registerHelper 'Post', ->
	postId = Template.instance().data.params.postId
	if postId
		return db.cms_posts.findOne({_id: postId})


Template.registerHelper 'Attachments', ()->
	postId = Template.instance().data.params.postId
	if postId
		post = db.cms_posts.findOne({_id: postId})
		if post and post.attachments
			return cfs.sites.find({_id: {$in: post.attachments}}).fetch()

Template.registerHelper 'SiteId', ->
	siteId = Template.instance().data.params.siteId
	return siteId

Template.registerHelper 'Site', ->
	siteId = Template.instance().data.params.siteId
	if siteId
		return db.cms_sites.findOne({_id: siteId})

Template.registerHelper "SubCategories", (parent)->
		if parent == "root"
			siteId = Template.instance().data.params.siteId
			return db.cms_categories.find({site: siteId, parent: null})
		else
			return db.cms_categories.find({parent: parent})

Template.registerHelper 'IndexPage', ->
	data = Template.instance().data
	if !data.params
		return false;
	else if data.params.categoryId
		return false
	else if data.params.postId
		return false
	else 
		return true

Template.registerHelper 'TagPage', ->
	tag = Template.instance().data.params.tag
	if tag
		return true
	return false

Template.registerHelper 'Tag', ->
	tag = Template.instance().data.params.tag
	return tag

Template.registerHelper 'PostPage', ->
	postId = Template.instance().data.params.postId
	if postId
		return true
	return false

Template.registerHelper 'Markdown', (text)->
	return Spacebars.SafeString(Markdown(text))

Template.registerHelper 'equals', (a, b)->
	return a == b

renderSite = (req, res, next) ->
	site = db.cms_sites.findOne({_id: req.params.siteId})
	
	templateName = 'site_theme_' + site.theme
	layout = site.layout
	if !layout
		layout = Assets.getText('themes/default.html')
	SSR.compileTemplate('site_theme_' + site.theme, layout);

	html = SSR.render templateName, 
		params: req.params

	res.end(html);

# JsonRoutes.add "get", "/site/:siteId", (req, res, next)->
#   res.statusCode = 302;
#   res.setHeader "Location", "./s/home"
#   res.end();

JsonRoutes.add "get", "/site/:siteId", renderSite  

JsonRoutes.add "get", "/site/:siteId/c/:categoryId", renderSite  

JsonRoutes.add "get", "/site/:siteId/p/:postId", renderSite  

JsonRoutes.add "get", "/site/:siteId/t/:tag", renderSite  