

Meteor.publish 'organizations', (spaceId)->
	
	unless this.userId
		return this.ready()
	
	unless spaceId
		return this.ready()

	console.log '[publish] organizations for space ' + spaceId

	return db.organizations.find({space: spaceId}, {fields: {name:1, children: 1, parent: 1}});
