

Meteor.publish 'space_users', (spaceId)->
	
	unless this.userId
		return this.ready()
	
	unless spaceId
		return this.ready()

	console.log '[publish] space_users for space ' + spaceId

	return db.space_users.find({space: spaceId}, {fields: {name:1, user: 1, organization: 1, user_accepted:1, managers: 1}});
