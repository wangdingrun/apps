@Users = db.users
@spaces = db.spaces
@space_users = db.space_users
@organizations = db.organizations


@AdminConfig = 
	name: "Steedos Admin"
	skin: "blue"
	userSchema: null,
	userSchema: db.users._simpleSchema,
	autoForm:
		omitFields: ['createdAt', 'updatedAt', 'created', 'created_by', 'modified', 'modified_by']
	collections: 
		spaces: db.spaces.adminConfig
		organizations: db.organizations.adminConfig
		space_users: db.space_users.adminConfig

# set first user as admin
if Meteor.isServer
	adminUser = Meteor.users.findOne({},{sort:{createdAt:1}})
	if adminUser
		adminUserId = adminUser._id
		if !Roles.userIsInRole(adminUserId, ['admin'])
			Roles.addUsersToRoles adminUserId, ['admin'], Roles.GLOBAL_GROUP

if Meteor.isClient
	Meteor.startup ->
		Tracker.autorun ->
			debugger;
			if AdminTables["spaces"]
				AdminTables["spaces"].selector = {_id: Session.get("spaceId")}
			if AdminTables["space_users"]
				AdminTables["space_users"].selector = {space: Session.get("spaceId")}
			if AdminTables["organizations"]
				AdminTables["organizations"].selector = {space: Session.get("spaceId")}