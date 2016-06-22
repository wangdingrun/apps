db.cms_tags = new Mongo.Collection("cms_tags");

db.cms_tags._simpleSchema = new SimpleSchema
    site: 
        type: String,
        autoform: 
            type: "select",
            options: ->
                options = []
                objs = db.cms_sites.find()
                objs.forEach (obj) ->
                    options.push
                        label: obj.name,
                        value: obj._id
                return options
    name: 
        type: String,

    sub_tags:
        type: [String],
        optional: true,
        autoform: 
            type: 'tags'
    image:
        type: String,
        optional: true,

    created: 
        type: Date,
        optional: true
    created_by:
        type: String,
        optional: true
    modified:
        type: Date,
        optional: true
    modified_by:
        type: String,
        optional: true
    
if Meteor.isClient
    db.cms_tags._simpleSchema.i18n("cms_tags")

db.cms_tags.attachSchema(db.cms_tags._simpleSchema)


db.cms_tags.adminConfig = 
    icon: "globe"
    color: "blue"
    tableColumns: [
        {name: "name"},
        {name: "subTags"},
        {name: "modified"},
    ]
    selector: {owner: -1}


     