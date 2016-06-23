  Meteor.publish 'cms_sites', (spaceId)->
  
    unless this.userId
      return this.ready()
    
    unless spaceId
      return this.ready()

    console.log '[publish] cms_sites for user ' + this.userId

    return db.cms_sites.find({space: spaceId})