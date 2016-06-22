Template.cms_theme_default.helpers
	Posts: (siteId, tag, limit, skip)->
		if !limit 
			limit = 5
		skip = 0
		if siteId and tag
			return db.cms_posts.find({site: siteId, tags: tag}, {sort: {posted: -1}, limit: limit, skip: skip})
		else if siteId
			return db.cms_posts.find({site: siteId}, {sort: {posted: -1}, limit: limit, skip: skip})

	Post: ()->
		postId = Session.get("postId")
		if postId
			return db.cms_posts.findOne({_id: postId})

	Attachments: ()->
		postId = Session.get("postId")
		if postId
			post = db.cms_posts.findOne({_id: postId})
			if post and post.attachments
				return db.cms_files.find({_id: {$in: post.attachments}}).fetch()

	SiteId: ->
		siteId = Session.get("siteId")
		return siteId

	Sites: ->
		return db.cms_sites.find()

	Site: ->
		siteId = Session.get("siteId")
		if siteId
			return db.cms_sites.findOne({_id: siteId})

	Tag: ->
		tag = Session.get("tag")
		return tag

	Markdown: (text)->
		if text
			return Spacebars.SafeString(Markdown(text))

Template.cms_theme_default.events
	"click .navigation": (e, t)->
		a = $(e.target).closest('a');
		router = a[0]?.dataset["router"]
		if router
			NavigationController.go router