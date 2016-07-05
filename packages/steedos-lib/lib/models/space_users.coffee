db.space_users = new Meteor.Collection('space_users')

db.space_users._simpleSchema = new SimpleSchema
	space: 
		type: String,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId");
	name: 
		type: String,
		max: 50,
	email:
		type: String,
		regEx: SimpleSchema.RegEx.Email,
	user:
		type: String,
		optional: true,
		autoform:
			omit: true

	organization: 
		type: String,
		autoform: 
			type: "selectorg"

	manager: 
		type: String,
		optional: true,
		autoform:
			type: "selectuser"

	user_accepted: 
		type: Boolean,
		optional: true,
		autoform: 
			defaultValue: true

	created:
		type: Date,
		optional: true
		autoform:
			omit: true
	created_by:
		type: String,
		optional: true
		autoform:
			omit: true
	modified:
		type: Date,
		optional: true
		autoform:
			omit: true
	modified_by:
		type: String,
		optional: true
		autoform:
			omit: true
	apps:
		type: Object
		optional: true,
		blackbox: true
		autoform:
			omit: true

if Meteor.isClient
	db.space_users._simpleSchema.i18n("space_users")

db.space_users.attachSchema(db.space_users._simpleSchema);



db.space_users.helpers
	space_name: ->
		space = db.spaces.findOne({_id: this.space});
		return space?.name
	organization_name: ->
		organization = db.organizations.findOne({_id: this.organization});
		return organization?.fullname


if (Meteor.isServer) 

	db.space_users.before.insert (userId, doc) ->
		doc.created_by = userId;
		doc.created = new Date();
		doc.modified_by = userId;
		doc.modified = new Date();

		if !doc.space
			throw new Meteor.Error(400, "space_users_error_space_required");

		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, "space_users_error_space_not_found");
		if userId and space.admins.indexOf(userId) < 0
			throw new Meteor.Error(400, "space_users_error_space_admins_only");
			
		creator = db.users.findOne(userId)

		if (!doc.user) && (doc.email)
			userObj = db.users.findOne({"emails.address": doc.email});
			if (userObj)
				doc.user = userObj._id
				doc.name = userObj.name
			else
				user = {}
				if !doc.name
					doc.name = doc.email.split('@')[0]
				doc.user = db.users.insert
					emails: [{address: doc.email, verified: false}]
					name: doc.name
					locale: creator.locale
					spaces_invited: [space._id]

		if !doc.user
			throw new Meteor.Error(400, "space_users_error_user_required");

		if !doc.name
			throw new Meteor.Error(400, "space_users_error_name_required");

		# check space_users exists
		oldUser=db.users.findOne
			"emails.address":doc.email
		existed=db.space_users.find
			"user":oldUser._id,"space":doc.space
		if existed.count()>0
			throw new Meteor.Error(400, "space_users_error_space_users_exists");

	db.space_users.after.insert (userId, doc) ->
		console.log("db.space_users_after.insert");
		if doc.organization
			organizationObj = db.organizations.findOne(doc.organization)
			organizationObj.updateUsers();

		db.users_changelogs.direct.insert
			operator: userId
			space: doc.space
			operation: "add"
			user: doc.user
			user_count: db.space_users.find({space: doc.space, user_accepted: true}).count()

	db.space_users.before.update (userId, doc, fieldNames, modifier, options) ->
		modifier.$set = modifier.$set || {};

		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, "space_users_error_space_not_found");
		# only space admin can update space_users
		if space.admins.indexOf(userId) < 0
			throw new Meteor.Error(400, "space_users_error_space_admins_only");

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();

		if modifier.$set.email
			if modifier.$set.email != doc.email
				throw new Meteor.Error(400, "space_users_error_email_readonly");
		if modifier.$set.space
			if modifier.$set.space != doc.space
				throw new Meteor.Error(400, "space_users_error_space_readonly");
		if modifier.$set.user
			if modifier.$set.user != doc.user
				throw new Meteor.Error(400, "space_users_error_user_readonly");
	
	db.space_users.after.update (userId, doc, fieldNames, modifier, options) ->
		console.log("db.space_users.after.update");
		self = this
		modifier.$set = modifier.$set || {};

		# if modifier.$set.name
		# 	db.users.direct.update {_id: doc.user},
		# 		$set:
		# 			name: doc.name

		if modifier.$set.organization
			organizationObj = db.organizations.findOne(modifier.$set.organization)
			organizationObj.updateUsers();
		if this.previous.organization
			organizationObj = db.organizations.findOne(this.previous.organization)
			organizationObj.updateUsers();

		if modifier.$set.hasOwnProperty("user_accepted")
			if this.previous.user_accepted != modifier.$set.user_accepted
				db.users_changelogs.direct.insert
					operator: userId
					space: doc.space
					operation: modifier.$set.user_accepted ? "enable" : "disable"
					user: doc.user
					user_count: db.space_users.find({space: doc.space, user_accepted: true}).count()


	db.space_users.before.remove (userId, doc) ->
		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, "space_users_error_space_not_found");
		# only space admin can remove space_users
		if space.admins.indexOf(userId) < 0
			throw new Meteor.Error(400, "space_users_error_space_admins_only");


	db.space_users.after.remove (userId, doc) ->
		console.log("db.space_users.after.remove");
		if doc.organization
			organizationObj = db.organizations.findOne(doc.organization)
			organizationObj.updateUsers();

		db.users_changelogs.direct.insert
			operator: userId
			space: doc.space
			operation: "delete"
			user: doc.user
			user_count: db.space_users.find({space: doc.space, user_accepted: true}).count()


	Meteor.publish 'space_users', (spaceId)->
		unless this.userId
			return this.ready()

		user = db.users.findOne(this.userId);

		selector = {}
		if spaceId
			selector.space = spaceId
		else 
			selector.space = {$in: user.spaces()}

		console.log '[publish] space_users ' + spaceId

		return db.space_users.find(selector)
	


	Meteor.publish 'my_space_users', ()->
		unless this.userId
			return this.ready()

		console.log '[publish] my_space_users '

		return db.space_users.find({user: this.userId})
	