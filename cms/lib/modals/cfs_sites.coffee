cfs.sites = new FS.Collection("sites",
  stores: [new FS.Store.FileSystem("sites")]
)

cfs.sites.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc) ->
    true
  remove: (userId, doc) ->
    true
  download: (userId)->
    true
