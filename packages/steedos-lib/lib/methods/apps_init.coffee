if Meteor.isServer
	Meteor.methods
		core_apps_init: ()->
			db.apps.remove({})
			_.each db.apps.core_apps, (v, k)->
				db.apps.insert(v)

		space_apps_init: (spaceId)->
			if !spaceId 
				return false;

			spaceAppsCount = db.apps.find({space: spaceId}).count()
			if spaceAppsCount>0
				return false;
			
			apps = db.apps.find({space: {$exists: false}}).fetch()
			console.log "Initializing apps for space " + spaceId
			_.each apps, (app)->
				space_app = _.clone(app)
				delete space_app._id
				space_app.space = spaceId
				db.apps.insert(space_app)

			return true