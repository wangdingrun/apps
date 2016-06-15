Meteor.startup ->

    @cms_posts = db.cms_posts
    @cms_sites = db.cms_sites
    AdminConfig?.collections_add
        cms_sites: db.cms_sites.adminConfig
        cms_posts: db.cms_posts.adminConfig


if Meteor.isClient
    Meteor.startup ->
        Tracker.autorun ->
            if Meteor.userId()
                AdminTables["cms_sites"]?.selector = {owner: Meteor.userId()}
                AdminTables["cms_posts"]?.selector = {owner: Meteor.userId()}