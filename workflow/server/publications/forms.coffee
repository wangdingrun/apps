  Meteor.publish 'forms', (spaceId)->
  
    unless this.userId
      return this.ready()
    
    unless spaceId
      return this.ready()

    console.log '[publish] forms for space ' + spaceId

    return db.forms.find({space: spaceId}, {fields: {category: 1, current: 1, historys: 1}})