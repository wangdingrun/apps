@Users = db.users
@spaces = db.spaces
@space_users = db.space_users
@organizations = db.organizations

db.spaces.adminConfig = 
	icon: "globe"
	label: ->
		return t("db_spaces")
	tableColumns: [
		{name: "name"},
		{name: "owner_name()"},
		{name: "is_paid"},
	]
	extraFields: ["owner"]
	newFormFields: "name"
	selector: {_id: -1}

db.organizations.adminConfig =
	icon: "sitemap"
	label: ->
		return t("db_organizations")
	tableColumns: [
		{name: "fullname"},
		{name: "users_count()"},
		{name: "space_name()"},
	]
	extraFields: ["space", "name", "users"]
	newFormFields: "space,name,parent"
	editFormFields: "name,parent"
	selector: {space: "-1"}

db.space_users.adminConfig = 
		icon: "users"
		label: ->
			return t("db_space_users")
		tableColumns: [
			{name: "name"},
			{name: "organization_name()"},
			{name: "space_name()"},
			{name: "user_accepted"}
		]
		extraFields: ["space", "user", 'organization', "manager"]
		newFormFields: "space,email"
		editFormFields: "space,name,manager,user_accepted"
		selector: {space: "-1"}

@AdminConfig = 
	name: "Steedos Admin"
	skin: "green"
	userSchema: null,
	userSchema: db.users._simpleSchema,
	autoForm:
		omitFields: ['createdAt', 'updatedAt', 'created', 'created_by', 'modified', 'modified_by']
	collections: 
		#spaces: db.spaces.adminConfig
		organizations: db.organizations.adminConfig
		space_users: db.space_users.adminConfig

# set first user as admin
# if Meteor.isServer
# 	adminUser = Meteor.users.findOne({},{sort:{createdAt:1}})
# 	if adminUser
# 		adminUserId = adminUser._id
# 		if !Roles.userIsInRole(adminUserId, ['admin'])
# 			Roles.addUsersToRoles adminUserId, ['admin'], Roles.GLOBAL_GROUP

if Meteor.isClient
	Meteor.startup ->
		Tracker.autorun ->
			if Session.get("spaceId")
				if AdminTables["spaces"]
					AdminTables["spaces"].selector = {_id: Session.get("spaceId")}
				if AdminTables["space_users"]
					AdminTables["space_users"].selector = {space: Session.get("spaceId")}
				if AdminTables["organizations"]
					AdminTables["organizations"].selector = {space: Session.get("spaceId")}