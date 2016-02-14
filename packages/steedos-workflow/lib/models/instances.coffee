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


	Meteor.publish 'instances_pending', (spaceId)->

		unless this.userId
			return this.ready()
		
		unless spaceId
			return this.ready()

		return db.instances.find({space: spaceId}, {fields: {name:1, created:1, form:1, flow: 1, space:1}})


