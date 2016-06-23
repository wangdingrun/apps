db.cms_categories = new Mongo.Collection("cms_categories");

db.cms_categories._simpleSchema = new SimpleSchema
	space: 
		type: String,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId");
	site: 
		type: String,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Session.get("siteId");
	name: 
		type: String,

	description: 
		type: String,
		optional: true,
		autoform: 
			rows: 3
	# tags:
	# 	type: [String],
	# 	optional: true,
	# 	autoform: 
	# 		type: 'tags'
	# slug: 
	# 	type: String,
	# 	optional: true,
	# image:
	# 	type: String,
	# 	optional: true,

	parent: 
		type: String,
		optional: true,
		autoform: 
			options:  () ->
				categories = db.cms_categories.find().map (category) ->
					return {
						value: category._id,
						label: category.name
					}
				return categories;

	order: 
		type: Number,
		optional: true,

	# show post list on website homepage
	featured: 
		type: Boolean,
		optional: true,
		defaultValue: true,

	# show post list on website top menu
	menu: 
		type: Boolean,
		optional: true,
		defaultValue: true,

	created: 
		type: Date,
		optional: true
	created_by:
		type: String,
		optional: true
	modified:
		type: Date,
		optional: true
	modified_by:
		type: String,
		optional: true
	
if Meteor.isClient
	db.cms_categories._simpleSchema.i18n("cms_categories")

db.cms_categories.attachSchema(db.cms_categories._simpleSchema)

db.cms_categories.adminConfig = 
	icon: "ion ion-ios-albums-outline"
	color: "blue"
	tableColumns: [
		{name: "name"},
		{name: "modified"},
	]
	selector: {owner: -1}


	 