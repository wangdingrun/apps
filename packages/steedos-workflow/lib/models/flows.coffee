db.flows = new Meteor.Collection('flows')

if Meteor.isServer
    db.flows.before.insert (userId, doc) ->
        doc.created_by = userId;
        doc.created = new Date();
        if doc.current
            doc.current.created_by = userId;
            doc.current.created = new Date();
            doc.current.modified_by = userId;
            doc.current.modified = new Date();


