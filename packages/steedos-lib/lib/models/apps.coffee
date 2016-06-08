db.apps = new Meteor.Collection('apps')

db.apps.core_apps = 
    workflow:
        url: "/workflow"
        name: "Steedos Workflow"
        icon: "ion-ios-list-outline"
        internal: true
        menu: true
    chat:
        url: "/chat"
        name: "Steedos Chat"
        icon: "ion-ios-chatboxes-outline"
        menu: true
    drive: 
        url: "/drive"
        name: "Steedos Drive"
        secret: "8762-fcb369b2e85"
        icon: "ion-ios-folder-outline"
        menu: true
    # calendar: 
    #     url: "/calendar"
    #     name: "Steedos Calendar"
    #     secret: "8762-fcb369b2e85"
    #     icon: "ion-ios-list-outline"
    # mail:
    #     url: "https://mail.steedos.com"
    #     name: "Steedos Mail"
    #     icon: "ion-ios-email-outline"
    designer:
        url: "/designer"
        name: "Flow Designer"
        icon: "ion-ios-shuffle"
    admin:
        url: "/admin"
        name: "Steedos Admin"
        icon: "ion-ios-gear-outline"
        internal: true
        menu: true

db.apps.core_apps_array = []
_.each db.apps.core_apps, (v, k)->
    v._id = k
    db.apps.core_apps_array.push(v)