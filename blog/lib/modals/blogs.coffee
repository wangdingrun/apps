db.blogs = new Meteor.Collection('blogs')

db.blogs._simpleSchema = new SimpleSchema
	name: 
		type: String,
		max: 200
	owner: 
		type: String,
		autoform:
			type: "selectuser"
			defaultValue: ->
				return Meteor.userId()
	admins: 
		type: [String],
		autoform:
			type: "selectuser"
			multiple: true

if Meteor.isClient
	db.blogs._simpleSchema.i18n("db_blogs")

db.blogs.attachSchema(db.blogs._simpleSchema)

