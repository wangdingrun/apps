db.blog_categories = new Mongo.Collection("blog_categories");

db.blog_categories._simpleSchema = new SimpleSchema
	blog: 
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
				categories = db.blog_categories.find().map (category) ->
					return {
						value: category._id,
						label: category.name
					}
				return categories;

	
if Meteor.isClient
	db.blog_categories._simpleSchema.i18n("db_blog_categories")

db.blog_categories.attachSchema(db.blog_categories._simpleSchema)


	 