
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
