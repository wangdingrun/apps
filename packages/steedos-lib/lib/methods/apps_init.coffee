if Meteor.isServer
	Meteor.methods
		apps_init: ()->
			db.apps.remove({});
			_.each db.apps.core_apps, (v, k)->
				v._id = k
				db.apps.insert(v)

