CMS = {}

if Meteor.isClient
	CMS.helpers =
		Posts: (limit, skip)->
			if !limit 
				limit = 5
			skip = 0
			siteId = FlowRouter.current().params.siteId
			tag = FlowRouter.current().params.tag
			organizationId = FlowRouter.current().params.organizationId

			if siteId and tag
				return db.cms_posts.find({site: siteId, tags: tag}, {sort: {posted: -1}, limit: limit, skip: skip})
			else if siteId and organizationId
				return db.cms_posts.find({site: siteId, organization: organizationId}, {sort: {posted: -1}, limit: limit, skip: skip})
			else if siteId
				return db.cms_posts.find({site: siteId}, {sort: {posted: -1}, limit: limit, skip: skip})
		
		Organization: ()->
			organizationId = FlowRouter.current().params.organizationId
			if organizationId
				return db.organizations.findOne(organizationId)

		OrganizationPosts: (limit, skip)->
			if !limit 
				limit = 5
			skip = 0
			organizationId = FlowRouter.current().params.organizationId
			if siteId and organizationId
				return db.cms_posts.find({site: siteId, organization: organizationId}, {sort: {posted: -1}, limit: limit, skip: skip})

		Post: ()->
			postId = FlowRouter.current().params.postId
			if postId
				return db.cms_posts.findOne({_id: postId})

		PostURL: (postId)->
			siteId = FlowRouter.current().params.siteId
			if siteId
				organizationId = FlowRouter.current().params.organizationId
				if organizationId
					return "/cms/" + siteId + "/o/" +  organizationId + "/p/" + postId
				tag = FlowRouter.current().params.tag
				if tag
					return "/cms/" + siteId + "/t/" +  tag + "/p/" + postId

		PostSummary: ->
			if this.body
				return this.body.substring(0, 100)

		Attachments: ()->
			postId = FlowRouter.current().params.postId
			if postId
				post = db.cms_posts.findOne({_id: postId})
				if post and post.attachments
					return cfs.sites.find({_id: {$in: post.attachments}}).fetch()

		SiteId: ->
			siteId = FlowRouter.current().params.siteId
			return siteId

		Sites: ->
			return db.cms_sites.find()

		Site: ->
			siteId = FlowRouter.current().params.siteId
			if siteId
				return db.cms_sites.findOne({_id: siteId})

		Tags: ->
			siteId = FlowRouter.current().params.siteId
			if siteId
				return db.cms_tags.find({site: siteId})
		Tag: ->
			tag = FlowRouter.current().params.tag
			return tag

		Markdown: (text)->
			if text
				return Spacebars.SafeString(Markdown(text))