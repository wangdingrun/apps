  Meteor.publish 'cms_posts', (siteId)->
  
    unless this.userId
      return this.ready()
    
    console.log '[publish] cms_posts for site ' + siteId

    selector = {}
    if siteId
        selector.site = siteId

    return db.cms_posts.find(selector, {sort: {created: -1}})