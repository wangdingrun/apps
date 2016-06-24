Meteor.publishComposite 'adminCollectionDoc', (collection, id) ->
	check collection, String
	check id, Match.OneOf(String, Mongo.ObjectID)
	if true #Roles.userIsInRole this.userId, ['admin']
		find: ->
			adminCollectionObject(collection).find(id)
		children: AdminConfig?.collections?[collection]?.children or []
	else
		@ready()

Meteor.publish 'adminCollectionsCount', (spaceId)->
	if (!spaceId)
		return this.ready()

	handles = []
	self = @

	_.each AdminTables, (table, name) ->
		id = new Mongo.ObjectID
		count = 0

		ready = false
		handles.push table.collection.find({space: spaceId}).observeChanges
			added: ->
				count += 1
				ready and self.changed 'adminCollectionsCount', id, {count: count}
			removed: ->
				count -= 1
				ready and self.changed 'adminCollectionsCount', id, {count: count}
		ready = true

		self.added 'adminCollectionsCount', id, {collection: name, count: count}

	self.onStop ->
		_.each handles, (handle) -> handle.stop()
	self.ready()

Meteor.publish null, ->
	Meteor.roles.find({})
