Meteor.publish 'cms_images', ->
    unless this.userId
        return this.ready()

    db.cms_images.find({"metadata.owner": this.userId})
