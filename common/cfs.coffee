Meteor.startup ->
	FS.HTTP.setBaseUrl("/api")

	@cfs = {}

	db.avatars = new FS.Collection "avatars",  
	  stores: [new FS.Store.FileSystem("avatars")]

	db.avatars.allow
		insert: ->
			return true;
		update: ->
			return true;
		remove: ->
			return true;
		download: ->
			return true;


	cfs.instances = new FS.Collection "instances",
		stores: [new FS.Store.FileSystem("instances")]

	cfs.instances.allow
		insert: ->
			return true;
		update: ->
			return true;
		remove: ->
			return true;
		download: ->
			return true;
