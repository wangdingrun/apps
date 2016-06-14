Meteor.startup ->
    Migrations.add
        version: 2
        up: ->
            db.apps.remove({})
            _.each db.apps.core_apps, (v, k)->
                db.apps.insert(v)