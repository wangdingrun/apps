  Meteor.publish 'cms_sites', ()->
  
    unless this.userId
      return this.ready()
    

    console.log '[publish] cms_sites for user ' + this.userId

    return db.cms_sites.find({owner: this.userId})