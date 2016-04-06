
Meteor.publish 'user_data', ()->
    
    unless this.userId
        return this.ready()

    return Meteor.users.find({_id: this.userId}, {fields: {name: 1, avatar: 1}})
