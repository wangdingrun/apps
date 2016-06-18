Template.springboard.helpers

	apps: ()->
		if Steedos.isMobile()
			return db.apps.find({mobile: true}, {sort: {sort_no:1}});
		else
			return db.apps.find({desktop: true}, {sort: {sort_no:1}});

	badge: (app_id)->
		app = db.apps.findOne(app_id)
		if app && app.url.startsWith("/workflow")
			c = db.box_counts.findOne(Steedos.getSpaceId());
			if c?.inbox_count >0
				return c.inbox_count;