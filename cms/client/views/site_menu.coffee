Template.cms_site_menu.helpers CMS.helpers

Template.cms_site_menu.helpers
    space_organization: ()->
        return db.organizations.findOne({is_company: true})
    organizations: (parent)->
        if parent
            return db.organizations.find({parent: parent})
        