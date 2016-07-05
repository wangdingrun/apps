# Add hooks used by many forms
AutoForm.addHooks [
		'admin_insert',
		'admin_update'
		# 'adminNewUser',
		# 'adminUpdateUser',
		# 'adminSendResetPasswordEmail',
		# 'adminChangePassword'
		],
	beginSubmit: ->
		$('.btn-primary').addClass('disabled')
	endSubmit: ->
		$('.btn-primary').removeClass('disabled')
	onError: (formType, error)->
		# 判断错误类型
		if error.error
			AdminDashboard.alertFailure TAPi18n.__ error.reason
		else
			AdminDashboard.alertFailure TAPi18n.__ error.message

		

AutoForm.hooks
	admin_insert:
		onSubmit: (insertDoc, updateDoc, currentDoc)->
			hook = @
			Meteor.call 'adminInsertDoc', insertDoc, Session.get('admin_collection_name'), (e,r)->
				if e
					hook.done(e)
				else if r.e
					hook.done(r.e)
				else
					adminCallback 'onInsert', [Session.get('admin_collection_name'), insertDoc, updateDoc, currentDoc], (collection) ->
						hook.done null, collection
			return false
		onSuccess: (formType, collection)->
			AdminDashboard.alertSuccess TAPi18n.__("flow_db_admin_successfully_created")
			FlowRouter.go "/admin/view/#{collection}"

	admin_update:
		onSubmit: (insertDoc, updateDoc, currentDoc)->
			hook = @
			Meteor.call 'adminUpdateDoc', updateDoc, Session.get('admin_collection_name'), @docId, (e,r)->
				if e
					hook.done(e)
				else if r.e
					hook.done(r.e)
				else
					adminCallback 'onUpdate', [Session.get('admin_collection_name'), insertDoc, updateDoc, currentDoc], (collection) ->
						hook.done null, collection
			return false
		onSuccess: (formType, collection)->
			AdminDashboard.alertSuccess TAPi18n.__("flow_db_admin_successfully_updated")

	# adminNewUser:
	# 	onSuccess: (formType, result)->
	# 		AdminDashboard.alertSuccess 'Created user'

	# adminUpdateUser:
	# 	onSubmit: (insertDoc, updateDoc, currentDoc)->
	# 		Meteor.call 'adminUpdateUser', updateDoc, Session.get('admin_id'), @done
	# 		return false
	# 	onSuccess: (formType, result)->
	# 		AdminDashboard.alertSuccess 'Updated user'

	# adminSendResetPasswordEmail:
	# 	onSuccess: (formType, result)->
	# 		AdminDashboard.alertSuccess 'Email sent'

	# adminChangePassword:
	# 	onSuccess: (operation, result, template)->
	# 		AdminDashboard.alertSuccess 'Password reset'
