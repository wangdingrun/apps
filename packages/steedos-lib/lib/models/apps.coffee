db.apps = new Meteor.Collection('apps')

db.apps._simpleSchema = new SimpleSchema
	space: 
		type: String,
		optional: true,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId");
	name:
		type: String
		max: 200
	url:
		type: String
		max: 200
	icon:
		type: String
		max: 200
	secret:
		type: String
		max: 200
		optional: true,
	internal:
		type: Boolean
		optional: true,
		autoform: 
			omit: true
	menu:
		type: Boolean
		optional: true,
	mobile:
		type: Boolean
		optional: true,
	desktop:
		type: Boolean
	sort_no:
		type: Number
		optional: true,

if Meteor.isClient
	db.apps._simpleSchema.i18n("apps")

db.apps.attachSchema db.apps._simpleSchema;

db.apps.core_apps = 
	workflow:
		url: "/workflow"
		name: "Steedos Workflow"
		icon: "ion-ios-list-outline"
		internal: true
		menu: true
		mobile: true
		desktop: true
		sort_no: 10
	chat:
		url: "/chat/channel/general"
		name: "Steedos Chat"
		icon: "ion-ios-chatboxes-outline"
		menu: true
		mobile: true
		desktop: true
		sort_no: 20
	drive: 
		url: "/drive"
		name: "Steedos Drive"
		secret: "8762-fcb369b2e85"
		icon: "ion-ios-folder-outline"
		menu: true
		mobile: true
		desktop: true
		sort_no: 30
	calendar: 
		url: "/drive/index.php/apps/calendar/"
		name: "Steedos Calendar"
		secret: "8762-fcb369b2e85"
		icon: "ion-ios-calendar-outline"
		mobile: true
		desktop: true
		sort_no: 40
	mail:
		url: "https://mail.steedos.com"
		name: "Steedos Mail"
		icon: "ion-ios-email-outline"
		desktop: true
		sort_no: 50
	designer:
		url: "/designer"
		name: "Flow Designer"
		icon: "ion-ios-shuffle"
		desktop: true
		sort_no: 60
	admin:
		url: "/admin"
		name: "Steedos Admin"
		icon: "ion-ios-gear-outline"
		internal: true
		menu: true
		mobile: true
		desktop: true
		sort_no: 70
