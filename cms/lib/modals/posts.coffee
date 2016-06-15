db.cms_posts = new Meteor.Collection('cms_posts')

db.cms_posts._simpleSchema = new SimpleSchema
	site: 
		type: Number,
	url: 
		type: String,
		optional: true,
		max: 500,
		autoform: 
			#type: "bootstrap-url",
			order: 10
	title: 
		type: String,
		optional: false,
		max: 500,
		autoform: 
			order: 20
	slug: 
		type: String,
		optional: true
	
	body: 
		type: String,
		optional: true,
		max: 3000,
		autoform: 
			rows: 5,
			order: 30
 
	htmlBody: 
		type: String,
		optional: true
		
	viewCount: 
		type: Number,
		optional: true
	commentCount: 
		type: Number,
		optional: true
	commenters: 
		type: [String],
		optional: true
	lastCommentedAt: 
		type: Date,
		optional: true
	clickCount: 
		type: Number,
		optional: true
	baseScore: 
		type: Number,
		decimal: true,
		optional: true
	upvotes: 
		type: Number,
		optional: true
	upvoters: 
		type: [String],
		optional: true
	downvotes: 
		type: Number,
		optional: true
	downvoters: 
		type: [String],
		optional: true
	score: 
		type: Number,
		decimal: true,
		optional: true
	# The post's status. 
	status: 
		type: Number,
		optional: true,
	sticky: 
		type: Boolean,
		optional: true,
		defaultValue: false,
		autoform: 
			leftLabel: "Sticky"
		
	# Whether the post is inactive. Inactive posts see their score recalculated less often
	inactive: 
		type: Boolean,
		optional: true
	
	# Save info for later spam checking on a post. We will use this for the akismet package
	userIP: 
		type: String,
		optional: true
	userAgent: 
		type: String,
		optional: true
	referrer: 
		type: String,
		optional: true

	# The post author's name
	author_name: 
		type: String,
		optional: true
	# The post author's `_id`. 
	author: 
		type: String,
		optional: true,

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
	posted: 
		type: Date,
		optional: true,
		autoform: 
			type: "bootstrap-datetimepicker"

db.cms_posts.config = 
	STATUS_PENDING: 1                                                                                      // 34
	STATUS_APPROVED: 2                                                                                     // 35
	STATUS_REJECTED: 3                                                                                     // 36
	STATUS_SPAM: 4                                                                                      // 37
	STATUS_DELETED: 5 

if Meteor.isClient
	db.cms_posts._simpleSchema.i18n("db_cms_posts")

db.cms_posts.attachSchema(db.cms_posts._simpleSchema)

