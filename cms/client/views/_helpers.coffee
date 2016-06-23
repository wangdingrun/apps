CMS.helpers =
	Posts: (limit, skip)->
		if !limit 
			limit = 5
		skip = 0
		siteId = Session.get("siteId")
		tag = Session.get("siteTag")
		siteCategory = Session.get("siteCategory")

		if siteId and tag
			return db.cms_posts.find({site: siteId, tags: tag}, {sort: {posted: -1}, limit: limit, skip: skip})
		else if siteId and siteCategory
			return db.cms_posts.find({site: siteId, category: siteCategory}, {sort: {posted: -1}, limit: limit, skip: skip})
		else if siteId
			return db.cms_posts.find({site: siteId}, {sort: {posted: -1}, limit: limit, skip: skip})
	
	Post: ()->
		postId = FlowRouter.current().params.postId
		if postId
			return db.cms_posts.findOne({_id: postId})

	PostURL: (postId)->
		siteId = Session.get("siteId")
		if siteId
			siteCategory = Session.get("siteCategory")
			tag = Session.get("siteTag")
			if siteCategory
				return "/cms/" + siteId + "/c/" +  siteCategory + "/p/" + postId
			else if tag
				return "/cms/" + siteId + "/t/" +  tag + "/p/" + postId
			else
				return "/cms/" + siteId + "/p/" + postId

	PostSummary: ->
		if this.body
			return this.body.substring(0, 200)

	Attachments: ()->
		postId = FlowRouter.current().params.postId
		if postId
			post = db.cms_posts.findOne({_id: postId})
			if post and post.attachments
				return cfs.sites.find({_id: {$in: post.attachments}}).fetch()

	CategoryId: ()->
		return Session.get("siteCategory")

	CategoryActive: (categoryId)->
		if Session.get("siteCategory") == categoryId
			return "active"

	Category: ()->
		siteCategory = Session.get("siteCategory")
		if siteCategory
			return db.cms_categories.findOne(siteCategory)

	ParentCategory: ()->
		siteCategory = Session.get("siteCategory")
		if siteCategory
			c = db.cms_categories.findOne(siteCategory)
			if c?.parent
				return db.cms_categories.findOne(c.parent)

	SubCategories: (parent)->
		if parent
			return db.cms_categories.find({parent: parent})
		else
			return db.cms_categories.find({parent: null})
			
	SubCategoriesCount: (parent)->
		return db.cms_categories.find({parent: parent}).count()

	SiteId: ->
		siteId = Session.get("siteId")
		return siteId

	Sites: ->
		return db.cms_sites.find()

	Site: ->
		siteId = Session.get("siteId")
		if siteId
			return db.cms_sites.findOne({_id: siteId})

	Tags: ->
		siteId = Session.get("siteId")
		if siteId
			return db.cms_tags.find({site: siteId})
	Tag: ->
		tag = Session.get("siteTag")
		return tag

	Markdown: (text)->
		if text
			return Spacebars.SafeString(Markdown(text))