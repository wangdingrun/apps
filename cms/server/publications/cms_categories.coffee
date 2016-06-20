  Meteor.publish 'cms_categories', (site_id)->
  
    unless this.userId
      return this.ready()
    
    unless site_id
      return this.ready()

    console.log '[publish] cms_categories for site ' + site_id

    return db.cms_categories.find({site: site_id}, {sort: {order: 1}})