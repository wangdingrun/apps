db.cms_categories = new Mongo.Collection("cms_categories");

db.cms_categories._simpleSchema = new SimpleSchema
	site: 
		type: Number,
	name: 
		type: String,
	description: 
		type: String,
		optional: true,
		autoform: 
			rows: 3
	order: 
		type: Number,
		optional: true,
	slug: 
		type: String,
		optional: true,
	image:
		type: String,
		optional: true,
	parentId: 
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

	
if Meteor.isClient
	db.cms_categories._simpleSchema.i18n("cms_categories")

db.cms_categories.attachSchema(db.cms_categories._simpleSchema)


	 