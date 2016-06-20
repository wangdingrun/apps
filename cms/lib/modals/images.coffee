db.cms_images = new FS.Collection("cms_images",
  stores: [new FS.Store.FileSystem("cms_images")]
)

db.cms_images.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc) ->
    true
  remove: (userId, doc) ->
    true
  download: (userId)->
    true
