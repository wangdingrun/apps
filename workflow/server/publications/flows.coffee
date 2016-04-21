  Meteor.publish 'flows', (spaceId)->
  
    unless this.userId
      return this.ready()
    
    unless spaceId
      return this.ready()

    console.log '[publish] flows for space ' + spaceId

    return db.flows.find({space: spaceId}, {fields: {name: 1, form: 1, state: 1}})