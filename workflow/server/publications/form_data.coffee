
	Meteor.publish 'form_data', (formId)->
		
		unless this.userId
			return this.ready()
		
		unless formId
			return this.ready()

		console.log '[publish] form ' + formId

		return db.forms.find({_id: formId})
