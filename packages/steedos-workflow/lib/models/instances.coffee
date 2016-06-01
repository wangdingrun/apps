db.instances = new Meteor.Collection('instances')

db.instances.helpers
	applicant_name: ->
		applicant = db.space_users.findOne({user: this.applicant});
		if applicant
			return applicant.name;
		else
			return ""
