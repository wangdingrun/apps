Template.registerHelper 'Title', ->
	siteId = Template.instance().data.params.siteId
	site = db.cms_sites.findOne({_id: siteId}, {fields: {name: 1}})

	return site?.name

Template.registerHelper 'Posts', (tag, limit, skip)->
	if !limit 
		limit = 5
	if !skip
		skip = 0
	siteId = Template.instance().data.params.siteId
	if siteId and tag
		return db.cms_posts.find({site: siteId, tags: tag}, {sort: {posted: -1}, limit: limit, skip: skip})
	else if siteId
		return db.cms_posts.find({site: siteId}, {sort: {posted: -1}, limit: limit, skip: skip})

Template.registerHelper 'Post', ->
	postId = Template.instance().data.params.postId
	if postId
		return db.cms_posts.findOne({_id: postId})

Template.registerHelper 'SiteId', ->
	siteId = Template.instance().data.params.siteId
	return siteId

Template.registerHelper 'Site', ->
	siteId = Template.instance().data.params.siteId
	if siteId
		return db.cms_sites.findOne({_id: siteId})

Template.registerHelper 'IndexPage', ->
	data = Template.instance().data
	if !data.params
		return false;
	else if data.params.tag
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
	theme = db.cms_themes.findOne({_id: site.theme})
	
	templateName = 'site_theme_' + site.theme
	SSR.compileTemplate('site_theme_' + site.theme, theme.html);

	html = SSR.render templateName, 
		params: req.params

	res.end(html);

# JsonRoutes.add "get", "/site/:siteId", (req, res, next)->
# 	res.statusCode = 302;
# 	res.setHeader "Location", "./s/home"
# 	res.end();

JsonRoutes.add "get", "/site/:siteId", renderSite  

JsonRoutes.add "get", "/site/:siteId/c/:categoryId", renderSite  

JsonRoutes.add "get", "/site/:siteId/p/:postId", renderSite  

JsonRoutes.add "get", "/site/:siteId/t/:tag", renderSite  