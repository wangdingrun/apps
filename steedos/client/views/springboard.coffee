Template.springboard.helpers

    apps: ()->
        if Steedos.isMobile()
            return db.apps.find({mobile: true}, {sort: {sort_no:1}});
        else
            return db.apps.find({desktop: true}, {sort: {sort_no:1}});