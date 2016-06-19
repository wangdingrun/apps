#Template['admin_home'].replaces('AdminDashboard');


Template.admin_home.helpers 
        spaceName: ->
                if Session.get("spaceId")
                        space = db.spaces.findOne(Session.get("spaceId"))
                        if space
                                return space.name

        isSpaceAdmin: ->
                if Session.get('spaceId')
                        s = db.spaces.findOne(Session.get('spaceId'))
                        if s
                                return s.admins.includes(Meteor.userId())

        isSpaceOwner: ->
                if Session.get('spaceId')
                        s = db.spaces.findOne(Session.get('spaceId'))
                        if s
                                return s.owner == Meteor.userId()

Template.admin_home.events

    "click .navigation": (e, t)->
        a = $(e.target).closest('a');
        router = a[0]?.dataset["router"]
        if router
            NavigationController.go router