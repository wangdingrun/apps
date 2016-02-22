db.instances = new Meteor.Collection('instances')

if Meteor.isServer

	Meteor.publish 'instance_data', (instanceId)->
		
		unless this.userId
			return this.ready()
		
		unless instanceId
			return this.ready()

		console.log '[publish] instance ' + instanceId

		instance = db.instances.find({_id: instanceId})

		return [
			db.instances.find({_id: instanceId}),
			db.flows.find({_id: instance.flow}),
			db.forms.find({_id: instance.form})
		]


	Meteor.publish 'instances_inbox', (spaceId)->

		unless this.userId
			return this.ready()
		
		unless spaceId
			return this.ready()

		return db.instances.find({space: spaceId, inbox_users: this.userId}, {fields: {name:1, created:1, form:1, flow: 1, space:1}})


	Meteor.publish 'instances_list', (spaceId, box)->

		unless this.userId
			return this.ready()
		
		unless spaceId
			return this.ready()

		query = {space: spaceId}
		if box == "inbox"
			query.inbox_users = this.userId;
		else if box == "outbox"
			query.outbox_users = this.userId;
		else if box == "draft"
			query.submitter = this.userId;
			query.state = "draft"
		else if box == "pending"
			query.submitter = this.userId;
			query.state = "pending"
		else if box == "completed"
			query.submitter = this.userId;
			query.state = "completed"
		else
			query.state = "none"

		return db.instances.find(query, {fields: {name:1, created:1, form:1, flow: 1, space:1}})



