Template.registerHelper 'Title', ->
	return this.params.siteId

Template.registerHelper 'Category', ->
	if this.params.categoryId
		return db.cms_categories.findOne({_id: this.params.categoryId})

Template.registerHelper 'Categories', ->
	if this.params?.siteId
		return categories = db.cms_categories.find({site: this.params.siteId})

Template.registerHelper 'Posts', (categoryId)->
	if categoryId
		return db.cms_posts.find({category: categoryId})
	else if this.params?.siteId
		return db.cms_posts.find({site: this.params.siteId})

Template.registerHelper 'Post', ->
	if this.params.postId
		return db.cms_posts.findOne({_id: this.params.postId})

Template.registerHelper 'Site', ->
	return db.cms_sites.findOne({_id: this.params.siteId})

Template.registerHelper 'IndexPage', ->
	if !this.params
		return false;
	else if this.params.categoryId
		return false
	else if this.params.postId
		return false
	else 
		return true

Template.registerHelper 'CategoryPage', ->
	if this.params.categoryId
		return true
	return false

Template.registerHelper 'PostPage', ->
	if this.params.postId
		return true
	return false

Template.registerHelper 'Markdown', (text)->
	return Spacebars.SafeString(Markdown(text))

renderSite = (req, res, next) ->
	site = db.cms_sites.findOne({_id: req.params.siteId})
	theme = db.cms_themes.findOne({_id: site.theme})
	
	templateName = 'site_theme_' + site.theme
	SSR.compileTemplate('site_theme_' + site.theme, theme.html);

	html = SSR.render templateName, 
		params: req.params

	res.end(html);

JsonRoutes.add "get", "/site/:siteId", renderSite  

JsonRoutes.add "get", "/site/:siteId/category/:categoryId", renderSite  

JsonRoutes.add "get", "/site/:siteId/post/:postId", renderSite  