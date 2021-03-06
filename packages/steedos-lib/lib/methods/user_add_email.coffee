if Meteor.isServer
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


if Meteor.isClient
    Steedos.users_add_email = ()->
        swal
            title: t("primary_email_needed"),
            text: t("primary_email_needed_description"),
            type: 'input',
            showCancelButton: false,
            closeOnConfirm: false,
            animation: "slide-from-top"
        , (inputValue) ->
            console.log("You wrote", inputValue);
            Meteor.call "users_add_email", inputValue, (error, result)->
                if result?.error
                    toastr.error result.message
                else
                    swal t("primary_email_updated"), "", "success"

    Tracker.autorun (c) ->

        if Meteor.user()
            primaryEmail = Meteor.user().emails?[0]?.address
            if !primaryEmail
                Steedos.users_add_email();