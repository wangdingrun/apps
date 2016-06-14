db.blog_pages = new Meteor.Collection('blog_pages')

db.blog_pages._simpleSchema = new SimpleSchema
	blog: 
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
	db.blog_pages._simpleSchema.i18n("db_blog_pages")

db.blog_pages.attachSchema(db.blog_pages._simpleSchema)

