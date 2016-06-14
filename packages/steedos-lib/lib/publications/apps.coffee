if Meteor.isServer
    Meteor.publish 'apps', (spaceId)->
        unless this.userId
            return this.ready()
        
        unless spaceId
            return this.ready()
            
        console.log '[publish] apps ' + spaceId

        appsCount = db.apps.find({space: spaceId}).count()
        if appsCount > 0
            return db.apps.find({space: spaceId});
        else
            return db.apps.find({space: {$exists: false}});
