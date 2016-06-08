Meteor.methods
	users_add_email: (email) ->
		if not @userId?
			return {error: true, message: "Login required."}
		if not email?
			return {error: true, message: "Email required."}
		if not /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)
			return {error: true, message: "Email format error."}
		if db.users.find({"emails.address": email}).count()>0
			return {error: true, message: "Email exists."}

		user = db.users.findOne(_id: this.userId)
		if user.emails? and user.emails.length > 0 
			db.users.direct.update {_id: this.userId}, 
				$push: 
					emails: 
						address: email
						verified: false
		else
			db.users.direct.update {_id: this.userId}, 
				$set: 
					steedos_id: email
					emails: [
						address: email
						verified: false
					]

		Accounts.sendVerificationEmail(this.userId, email);

		console.log("add email " + email + " for user " + this.userId)
		return {}
