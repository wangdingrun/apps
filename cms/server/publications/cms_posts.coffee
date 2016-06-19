  Meteor.publish 'cms_posts', (site_id)->
  
    unless this.userId
      return this.ready()
    
    unless site_id
      return this.ready()

    console.log '[publish] cms_posts for site ' + site_id

    return db.cms_posts.find({site: site_id}, {sort: {created: -1}})