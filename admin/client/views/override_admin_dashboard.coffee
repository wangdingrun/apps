Template['override_AdminDashboard'].replaces('AdminDashboard');


Template.AdminDashboard.helpers 
        spaceName: ->
                if Session.get("spaceId")
                        space = db.spaces.findOne(Session.get("spaceId"))
                        if space
                                return space.name