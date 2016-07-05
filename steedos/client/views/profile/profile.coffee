Template.profile.helpers

	schema: ->
		return db.users._simpleSchema;

	user: ->
		return Meteor.user()

	userId: ->
		return Meteor.userId()

	getGravatarURL: (user, size) ->
		if Meteor.user()
			return Meteor.absoluteUrl('avatar/' + Meteor.userId());


Template.profile.onRendered ->


Template.profile.onCreated ->

	@clearForm = ->
		@find('#oldPassword').value = ''
		@find('#Password').value = ''
		@find('#confirmPassword').value = ''

	@changePassword = (callback) ->
		instance = @

		oldPassword = $('#oldPassword').val()
		Password = $('#Password').val()
		confirmPassword = $('#confirmPassword').val()

		if !oldPassword or !Password or !confirmPassword
			toastr.warning t('Old_and_new_password_required')

		else if Password == confirmPassword
			Accounts.changePassword oldPassword, Password, (error) ->
				if error
					toastr.error t('Incorrect_Password')
				else
					toastr.success t('Password_changed_successfully')
					instance.clearForm();
					return callback()
		else
			toastr.error t('Confirm_Password_Not_Match')

		
Template.profile.events

	'click .change-password': (e, t) ->
		t.changePassword()

	'change .avatar-file': (event, template) ->
		file = event.target.files[0];
		fileObj = db.avatars.insert file
		# Inserted new doc with ID fileObj._id, and kicked off the data upload using HTTP
		Meteor.call "updateUserAvatar", fileObj._id
		setTimeout(()->
			imgURL = Meteor.absoluteUrl("avatar/" + Meteor.userId())
			$(".avatar-preview").attr("src", imgURL + "?time=" + new Date());
		,3000)
		
Meteor.startup ->
	
	AutoForm.hooks
		updateProfile:
			onSuccess: (formType, result) ->
				toastr.success t('Profile_saved_successfully')
				if this.updateDoc.$set.locale != this.currentDoc.locale
					toastr.success t('Language_changed_reloading')
					setTimeout ->
						Meteor._reload.reload()
					, 1000
				else
					FlowRouter.go("/")

			onError: (formType, error) ->
				if error.reason
					toastr.error error.reason
				else 
					toastr.error error
			