db.cms_categories = new Mongo.Collection("cms_categories");

db.cms_categories._simpleSchema = new SimpleSchema
	site: 
		type: String,
		autoform: 
			type: "select",
			options: ->
				options = []
				objs = db.cms_sites.find({}, {name:1, sort: {name:1}})
				objs.forEach (obj) ->
					options.push
						label: obj.name,
						value: obj._id
				return options
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
	icon: "globe"
	color: "blue"
	tableColumns: [
		{name: "name"},
		{modified: "modified"},
	]
	selector: {owner: -1}


	 