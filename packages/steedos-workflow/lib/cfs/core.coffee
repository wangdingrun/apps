
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


