Meteor.startup ->

    @cms_categories = db.cms_categories
    @cms_sites = db.cms_sites
    @cms_posts = db.cms_posts
    @cms_pages = db.cms_pages
    @cms_tags = db.cms_tags
    AdminConfig?.collections_add
        cms_categories: db.cms_categories.adminConfig
        cms_sites: db.cms_sites.adminConfig
        cms_posts: db.cms_posts.adminConfig
        cms_pages: db.cms_pages.adminConfig
        cms_tags: db.cms_tags.adminConfig


if Meteor.isClient
    Meteor.startup ->
        Tracker.autorun ->
            if Meteor.userId() and Session.get("spaceId")
                AdminTables["cms_sites"]?.selector = {owner: Meteor.userId(), space: Session.get("spaceId")}
            if Session.get("siteId")
                AdminTables["cms_categories"]?.selector = {site: Session.get("siteId")}
                AdminTables["cms_tags"]?.selector = {site: Session.get("siteId")}
                AdminTables["cms_posts"]?.selector = {site: Session.get("siteId")}
                AdminTables["cms_pages"]?.selector = {site: Session.get("siteId")}