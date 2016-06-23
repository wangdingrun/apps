  Meteor.publish 'cms_categories', (siteId)->
  
    unless this.userId
      return this.ready()
    
    unless siteId
      return this.ready()

    console.log '[publish] cms_categories for site ' + siteId

    return db.cms_categories.find({site: siteId}, {sort: {order: 1}})