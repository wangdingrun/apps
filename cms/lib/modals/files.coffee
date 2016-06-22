db.cms_files = new FS.Collection("cms_files",
  stores: [new FS.Store.FileSystem("cms_files")]
)

db.cms_files.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc) ->
    true
  remove: (userId, doc) ->
    true
  download: (userId)->
    true
