db.cms_posts = new Meteor.Collection('cms_posts')

db.cms_posts._simpleSchema = new SimpleSchema
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
	# category: 
	# 	type: String,
	# 	autoform: 
	# 		type: "select",
	# 		options: ->
	# 			options = []
	# 			objs = db.cms_categories.find({}, {})
	# 			objs.forEach (obj) ->
	# 				options.push
	# 					label: obj.name,
	# 					value: obj._id
	# 			return options
	# url: 
	# 	type: String,
	# 	optional: true,
	# 	max: 500,
	# 	autoform: 
	# 		#type: "bootstrap-url",
	# 		order: 10

	title: 
		type: String,
		optional: false,
		max: 500,
		autoform: 
			order: 20
	# summary: 
	# 	type: String,
	# 	optional: true,
	# 	autoform: 
	# 		order: 25
	# slug: 
	# 	type: String,
	# 	optional: true
	# 	autoform:
	# 		omit: true
	body: 
		type: String,
		optional: true,
		autoform: 
			rows: 10,
			order: 30
 
	# htmlBody: 
	# 	type: String,
	# 	optional: true
	# 	autoform:
	# 		omit: true
		
	attachments:
		type: [String]
		optional: true
	"attachments.$":
		autoform:
			type: 'fileUpload'
			collection: 'sites'
			accept: 'image/*'
			# triggers: 
			# 	onBeforeInsert: (fileObj) ->
			# 		if !fileObj.metadata
			# 			fileObj.metadata = {}
			# 		fileObj.metadata.site = Session.get("siteId")
			# 		return fileObj

	organization: 
		type: String,
		autoform: 
			type: "selectorg"

	users: 
		type: [String],
		optional: true,
		autoform:
			type: "selectuser"
			multiple: true
			
	tags:
		type: [String],
		optional: true,
		autoform: 
			type: 'tags'
		
	posted: 
		type: Date,
		optional: true,
		autoform: 
			type: "bootstrap-datetimepicker"
			
	viewCount: 
		type: Number,
		optional: true
		autoform:
			omit: true
	commentCount: 
		type: Number,
		optional: true
		autoform:
			omit: true
	commenters: 
		type: [String],
		optional: true
		autoform:
			omit: true
	lastCommentedAt: 
		type: Date,
		optional: true
		autoform:
			omit: true
	clickCount: 
		type: Number,
		optional: true
		autoform:
			omit: true
	baseScore: 
		type: Number,
		decimal: true,
		optional: true
		autoform:
			omit: true
	upvotes: 
		type: Number,
		optional: true
		autoform:
			omit: true
	upvoters: 
		type: [String],
		optional: true
		autoform:
			omit: true
	downvotes: 
		type: Number,
		optional: true
		autoform:
			omit: true
	downvoters: 
		type: [String],
		optional: true
		autoform:
			omit: true
	score: 
		type: Number,
		decimal: true,
		optional: true
		autoform:
			omit: true
	# The post's status. 
	status: 
		type: Number,
		optional: true,
		autoform:
			omit: true

	featured: 
		type: Boolean,
		optional: true,
		defaultValue: false,
		
	# Whether the post is inactive. Inactive posts see their score recalculated less often
	inactive: 
		type: Boolean,
		optional: true
		autoform: 
			omit: true
	
	# Save info for later spam checking on a post. We will use this for the akismet package
	userIP: 
		type: String,
		optional: true
		autoform: 
			omit: true
	userAgent: 
		type: String,
		optional: true
		autoform: 
			omit: true
	referrer: 
		type: String,
		optional: true
		autoform: 
			omit: true

	# The post author's name
	author_name: 
		type: String,
		optional: true
		autoform: 
			omit: true
	# The post author's `_id`. 
	author: 
		type: String,
		optional: true,
		autoform: 
			omit: true

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

db.cms_posts.config = 
	STATUS_PENDING: 1                                                                                      // 34
	STATUS_APPROVED: 2                                                                                     // 35
	STATUS_REJECTED: 3                                                                                     // 36
	STATUS_SPAM: 4                                                                                      // 37
	STATUS_DELETED: 5 

if Meteor.isClient
	db.cms_posts._simpleSchema.i18n("cms_posts")

db.cms_posts.attachSchema(db.cms_posts._simpleSchema)


db.cms_posts.adminConfig = 
	icon: "globe"
	color: "blue"
	tableColumns: [
		{name: "title"},
		{name: "author_name"},
		{name: "modified"},
	]
	selector: {owner: -1}



if Meteor.isServer
	
	db.cms_posts.before.insert (userId, doc) ->

		doc.created_by = userId
		doc.created = new Date()
		doc.modified_by = userId
		doc.modified = new Date()
		
		if !userId
			throw new Meteor.Error(400, t("cms_posts_error.login_required"));
		
		if !doc.author
			doc.author = userId
		if !doc.author_name
			user = db.users.findOne(userId)
			doc.author_name = user.name

		if !doc.posted
			doc.posted = new Date()

		# 暂时默认为已核准
		doc.status = db.cms_posts.config.STATUS_APPROVED


	db.cms_posts.after.insert (userId, doc) ->
			

	db.cms_posts.before.update (userId, doc, fieldNames, modifier, options) ->
		modifier.$set = modifier.$set || {};

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();


	db.cms_posts.after.update (userId, doc, fieldNames, modifier, options) ->
		self = this
		modifier.$set = modifier.$set || {}
		