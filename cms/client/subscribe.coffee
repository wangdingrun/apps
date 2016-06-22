Meteor.startup ->
    Tracker.autorun (c)->
        if Meteor.userId()
            Meteor.subscribe "cms_sites"
            Meteor.subscribe "cms_posts"
            Meteor.subscribe "cms_tags"         
            Meteor.subscribe "cms_files"    