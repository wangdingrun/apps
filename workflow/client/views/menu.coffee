Template.workflow_menu.helpers

    boxName: ->
        if Session.get("box")
            return t(Session.get("box"))

    inbox_count: ->
        badge = Steedos.getBadge(Session.get("spaceId"))
        if badge
            return badge
        return
