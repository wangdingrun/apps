db.cms_pages = new Meteor.Collection('cms_pages')

db.cms_pages._simpleSchema = new SimpleSchema
	site: 
		type: Number,
	title: 
		type: String,
	slug:
		type: String,
		optional: true
	content: 
		type: String,
		autoform: 
			rows: 10
	order: 
		type: Number,
		optional: true

if Meteor.isClient
	db.cms_pages._simpleSchema.i18n("db_cms_pages")

db.cms_pages.attachSchema(db.cms_pages._simpleSchema)

