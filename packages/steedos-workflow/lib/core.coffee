@Steedos = @db = {}

db.users =  Meteor.users;
db.organizations = new Meteor.Collection('organizations');
db.spaces = new Meteor.Collection('spaces');
db.space_users = new Meteor.Collection('space_users');

if Meteor.isClient
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