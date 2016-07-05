db.users = Meteor.users;

db.users.allow
	# Allow user update own profile
	update: (userId, doc, fields, modifier) ->
		if userId == doc._id
			return true

db.users._simpleSchema = new SimpleSchema
	name: 
		type: String,
	username: 
		type: String,
		unique: true,
		optional: true
	steedos_id: 
		type: String,
		optional: true
		unique: true,
		autoform: 
			type: "text"
			readonly: true
	company: 
		type: String,
		optional: true,
	mobile: 
		type: String,
		optional: true,
	locale: 
		type: String,
		optional: true,
		allowedValues: [
			"en-us",
			"zh-cn"
		],
		autoform: 
			type: "select",
			options: [{
				label: "简体中文",
				value: "zh-cn"
			},
			{
				label: "English",
				value: "en-us"
			}]
	
	email_notification:
		type: Boolean
		optional: true

	primary_email_verified:
		type: Boolean
		optional: true
		autoform: 
			omit: true
	last_logon:
		type: Date
		optional: true
		autoform: 
			omit: true
	is_cloudadmin:
		type: Boolean
		optional: true
		autoform: 
			omit: true
	is_deleted:
		type: Boolean
		optional: true,
		autoform:
			omit: true

if Meteor.isClient
	db.users._simpleSchema.i18n("users")

db.users.helpers
	spaces: ->
		spaces = []
		sus = db.space_users.find({user: this._id}, {fields: {space:1}})
		sus.forEach (su) ->
			spaces.push(su.space)
		return spaces;

	displayName: ->
		if this.name 
			return this.name
		else if this.username
			return this.username
		else if this.emails and this.emails[0]
			return this.emails[0].address


if Meteor.isServer

		
	db.users.checkEmailValid = (email) ->
		existed = db.users.find 
			"emails.address": email
		if existed.count()>0
			throw new Meteor.Error(400, "users_error_email_exists");

	db.users.checkUsernameValid = (username) ->
		existed = db.users.find 
			"username": username
		if existed.count()>0
			throw new Meteor.Error(400, "users_error_username_exists");

	db.users.before.insert (userId, doc) ->

		doc.created = new Date();
		doc.is_deleted = false;
		if userId
			doc.created_by = userId;

		if doc.services?.google
			if doc.services.google.email && !doc.emails
				doc.emails = [{
					address: doc.services.google.email,
					verified: true
				}]
			if doc.services.google.picture
				doc.avatarUrl = doc.services.google.picture

		if doc.services?.facebook
			if doc.services.facebook.email && !doc.emails
				doc.emails = [{
					address: doc.services.facebook.email,
					verified: true
				}]

		if (doc.emails && !doc.steedos_id)
			if doc.emails.length>0
				doc.steedos_id = doc.emails[0].address

		if (doc.profile?.name && !doc.name)
			doc.name = doc.profile.name

		if (doc.profile?.locale && !doc.locale)
			doc.locale = doc.profile.locale

		# if !doc.steedos_id
		# 	doc._id = db.users._makeNewID()
		# 	doc.steedos_id = doc._id 

		if !doc.name
			doc.name = doc.steedos_id.split('@')[0]

		# if !doc.username
		# 	doc.username = doc.steedos_id.replace("@","_").replace(".","_")

		# for steedos chat
		if !doc.type
			doc.type = "user"
		if !doc.active
			doc.active = true
		if !doc.roles
			doc.roles = ["user"]

		_.each doc.emails, (obj)->
			db.users.checkEmailValid(obj.address);
		

	db.users.after.insert (userId, doc) ->
		console.log("db.users.after.insert")
		if !(doc.spaces_invited?.length>0)
			db.spaces.insert
				name: doc.name + " " + trl("space")
				owner: doc._id
				admins: [doc._id]

		try
			# 发送让用户设置密码的邮件
			Accounts.sendEnrollmentEmail(doc._id, doc.emails[0].address)
		catch e
			console.log "after insert user: sendEnrollmentEmail, id: " + doc._id + ", " + e


	db.users.before.update  (userId, doc, fieldNames, modifier, options) ->
		if modifier.$unset && modifier.$unset.steedos_id == ""
			throw new Meteor.Error(400, "users_error_steedos_id_required");

		modifier.$set = modifier.$set || {};

		if doc.steedos_id && modifier.$set.steedos_id
			if modifier.$set.steedos_id != doc.steedos_id
				throw new Meteor.Error(400, "users_error_steedos_id_readonly");

		if userId
			modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();


	db.users.after.update (userId, doc, fieldNames, modifier, options) ->
		modifier.$set = modifier.$set || {};
		if modifier.$set.name
			db.space_users.direct.update({user: doc._id}, {$set: {name: modifier.$set.name}}, {multi: true})


	db.users.before.remove (userId, doc) ->
		throw new Meteor.Error(400, "users_error_cloud_admin_required");


			
	Meteor.publish 'userData', ->
		unless this.userId
			return this.ready()

		console.log '[publish] userData'

		db.users.find this.userId,
			fields:
				steedos_id: 1
				name: 1
				company: 1
				mobile: 1
				locale: 1
				username: 1
				utcOffset: 1
				settings: 1
				is_cloudadmin: 1

