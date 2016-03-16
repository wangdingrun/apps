
Meteor.publish 'cfs_instances', ()->

	unless this.userId
		return this.ready()

	return cfs.instances.find()

