@Steedos = @db = {}

db.users =  Meteor.users;
db.organizations = new Meteor.Collection('organizations');
db.spaces = new Meteor.Collection('spaces');
db.space_users = new Meteor.Collection('space_users');

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



if Meteor.isServer

	# publish users spaces
	# we only publish spaces current user joined.
	Meteor.publish 'my_spaces', ->
		unless this.userId
			return this.ready()

		console.log '[publish] user spaces'

		self = this;
		user = db.users.findOne(this.userId);
		userSpaces = user.spaces()

		handle2 = null

		# only return user joined spaces, and observes when user join or leave a space
		handle = db.space_users.find({user: this.userId}).observe
			added: (doc) ->
				if doc.space
					if userSpaces.indexOf(doc.space) < 0
						userSpaces.push(doc.space)
						observeSpaces()
			removed: (oldDoc) ->
				if oldDoc.space
					self.removed "spaces", oldDoc.space
					userSpaces = _.without(userSpaces, oldDoc.space)

		observeSpaces = ->
			if handle2
				handle2.stop();
			handle2 = db.spaces.find({_id: {$in: userSpaces}}).observe
				added: (doc) ->
					self.added "spaces", doc._id, doc;
					userSpaces.push(doc._id)
				changed: (newDoc, oldDoc) ->
					self.changed "spaces", newDoc._id, newDoc;
				removed: (oldDoc) ->
					self.removed "spaces", oldDoc._id
					userSpaces = _.without(userSpaces, oldDoc._id)

		observeSpaces();

		self.ready();

		self.onStop ->
			handle.stop();
			if handle2
				handle2.stop();
		