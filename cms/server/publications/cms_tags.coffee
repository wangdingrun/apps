  Meteor.publish 'cms_tags', (site_id)->
  
    unless this.userId
      return this.ready()
    
    console.log '[publish] cms_tags for user ' + this.userId

    return db.cms_tags.find()