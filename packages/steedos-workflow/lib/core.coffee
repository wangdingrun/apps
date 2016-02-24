@Steedos = @db = {}

db.users =  Meteor.users;
db.organizations = new Meteor.Collection('organizations');
db.spaces = new Meteor.Collection('spaces');
db.space_users = new Meteor.Collection('space_users');

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
			type: "select2",
			options: [{
				label: "Chinese",
				value: "zh-cn"
			},
			{
				label: "English",
				value: "en-us"
			}]
	timezone: 
		type: String,
		optional: true,
		autoform:
			type: "select2",
			options: ->
				if Meteor.isClient
					return Steedos._timezones

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
		else if this.emails[0]
			return this.emails[0].address

	avatarURL: ->
		if this.avatar
			return "/api/files/avatars/" + this.avatar
		else if this.username
			return "/avatar/" + this.username
		else if this.emails && this.emails.length>0
			return "/avatar/" + this.emails[0].address

