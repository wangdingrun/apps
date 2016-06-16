Meteor.startup ->
    Tracker.autorun (c)->
        if Meteor.userId()
            Meteor.subscribe "cms_sites"