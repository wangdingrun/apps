Meteor.publish 'cms_files', ->
    unless this.userId
        return this.ready()

    db.cms_files.find({"metadata.owner": this.userId})
