CMS = {}

if Meteor.isClient
    CMS.helpers =
        Posts: (siteId, tag, limit, skip)->
            if !limit 
                limit = 5
            skip = 0
            if siteId and tag
                return db.cms_posts.find({site: siteId, tags: tag}, {sort: {posted: -1}, limit: limit, skip: skip})
            else if siteId
                return db.cms_posts.find({site: siteId}, {sort: {posted: -1}, limit: limit, skip: skip})
        
        Organization: ()->
            cms_organization_id = Session.get("cms_organization_id")
            if cms_organization_id
                return db.organizations.findOne(cms_organization_id)

        OrganizationPosts: (siteId, limit, skip)->
            if !limit 
                limit = 5
            skip = 0
            cms_organization_id = Session.get("cms_organization_id")
            if siteId and cms_organization_id
                return db.cms_posts.find({site: siteId, organization: cms_organization_id}, {sort: {posted: -1}, limit: limit, skip: skip})

        Post: ()->
            postId = Session.get("postId")
            if postId
                return db.cms_posts.findOne({_id: postId})

        PostSummary: ->
            if this.body
                return this.body.substring(0, 100)

        Attachments: ()->
            postId = Session.get("postId")
            if postId
                post = db.cms_posts.findOne({_id: postId})
                if post and post.attachments
                    return cfs.sites.find({_id: {$in: post.attachments}}).fetch()

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
            tag = Session.get("tag")
            return tag

        Markdown: (text)->
            if text
                return Spacebars.SafeString(Markdown(text))