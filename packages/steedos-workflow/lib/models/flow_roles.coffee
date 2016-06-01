db.flow_roles = new Meteor.Collection('flow_roles')


db.flow_roles._simpleSchema = new SimpleSchema
	space: 
		type: String,
		optional: true,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId");
	name: 
		type: String,
		max: 200


if Meteor.isClient
	db.flow_roles._simpleSchema.i18n("flow_roles")

db.flow_roles.attachSchema(db.flow_roles._simpleSchema)

