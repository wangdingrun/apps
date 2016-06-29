FlowRouter.subscriptions = () ->
    this.register('userData', Meteor.subscribe('userData'))
    this.register('my_spaces', Meteor.subscribe('my_spaces'));
    this.register('apps', Meteor.subscribe('apps'));

if Meteor.isClient
    console.log "spaces loaded: " + db.spaces.find().count()
    console.log "apps loaded: " + db.apps.find().count()
    
    Tracker.autorun (c)->
        console.log "spaces loaded: " + db.spaces.find().count()
        console.log "apps loaded: " + db.apps.find().count()
        spaceId = Steedos.getSpaceId()
        if spaceId
            space = db.spaces.findOne(spaceId)
            if space
                Steedos.setSpaceId(space._id)
            else
                space = db.spaces.findOne()
                if space
                    Steedos.setSpaceId(space._id)