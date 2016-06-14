Template.springboard.helpers

    apps: ()->
        if Steedos.isMobile()
            return db.apps.find({mobile: true});
        else
            return db.apps.find({desktop: true});