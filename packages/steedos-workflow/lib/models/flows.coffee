db.flows = new Meteor.Collection('flows')



if Meteor.isServer

	Meteor.publish 'flow_data', (flowId)->
		
		unless this.userId
			return this.ready()
		
		unless flowId
			return this.ready()

		console.log '[publish] flow ' + flowId

		return db.flows.find({_id: flowId})
