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


if Meteor.isServer

	db.flow_roles.before.insert (userId, doc) ->

		doc.created_by = userId;
		doc.created = new Date();

		if !doc.space
			throw new Meteor.Error(400, "space_users_error_space_required");


	db.flow_roles.before.update (userId, doc, fieldNames, modifier, options) ->

		modifier.$set = modifier.$set || {};

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();


	db.flow_roles.before.remove (userId, doc) ->

		if db.flow_positions.find({role: doc._id}).count()>0
			throw new Meteor.Error(400, "flow_roles_error_positions_exists");