Template['override_AdminDashboard'].replaces('AdminDashboard');


Template.AdminDashboard.helpers 
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
