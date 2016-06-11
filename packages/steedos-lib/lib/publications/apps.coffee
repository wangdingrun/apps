if Meteor.isServer
    Meteor.publish 'apps', (spaceId)->
        unless this.userId
            return this.ready()
        
        unless spaceId
            return this.ready()
            
        console.log '[publish] apps' + spaceId
        return db.apps.find();
