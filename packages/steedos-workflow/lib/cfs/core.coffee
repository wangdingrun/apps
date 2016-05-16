
@cfs = {}

cfs.instances = new FS.Collection "instances",
        stores: [new FS.Store.FileSystem("instances")]

cfs.instances.allow
        insert: ->
                return true;
        update: ->
                return true;
        remove: ->
                return true;
        download: ->
                return true;

if Meteor.isServer
        Meteor.startup ->
                cfs.instances.files._ensureIndex({"metadata.instance": 1})
                cfs.instances.files._ensureIndex({"failures.copies.instances.doneTrying": 1})
                cfs.instances.files._ensureIndex({"copies.instances": 1})
                cfs.instances.files._ensureIndex({"uploadedAt": 1})