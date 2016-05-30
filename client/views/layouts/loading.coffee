Template.loading.onRendered ->
    $(document.body).addClass "loading";
    if (Session.get("spaceId"))
        FlowRouter.go("/space/" + Session.get("spaceId") + "/inbox/")

Template.loading.onDestroyed ->
    $(document.body).removeClass "loading";