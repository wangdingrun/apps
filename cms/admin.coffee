Meteor.startup ->

    @cms_sites = db.cms_sites
    @cms_posts = db.cms_posts
    @cms_pages = db.cms_pages
    @cms_categories = db.cms_categories
    AdminConfig?.collections_add
        cms_sites: db.cms_sites.adminConfig
        cms_posts: db.cms_posts.adminConfig
        cms_pages: db.cms_pages.adminConfig
        cms_categories: db.cms_categories.adminConfig


if Meteor.isClient
    Meteor.startup ->
        Tracker.autorun ->
            if Meteor.userId()
                AdminTables["cms_sites"]?.selector = {owner: Meteor.userId()}
                AdminTables["cms_categories"]?.selector = {owner: Meteor.userId()}
                AdminTables["cms_posts"]?.selector = {owner: Meteor.userId()}
                AdminTables["cms_pages"]?.selector = {owner: Meteor.userId()}