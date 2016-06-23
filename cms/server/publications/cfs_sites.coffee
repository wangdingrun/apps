Meteor.publish 'cfs_sites', (siteId)->
    unless this.userId
        return this.ready()

    unless siteId
      return this.ready()

    cfs.sites.find({site: siteId})
