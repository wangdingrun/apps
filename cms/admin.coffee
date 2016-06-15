Meteor.startup ->

    @cms_sites = db.cms_sites
    AdminConfig?.collections_add
        cms_sites: db.cms_sites.adminConfig