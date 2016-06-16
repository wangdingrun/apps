FlowRouter.route '/cms',
    action: (params, queryParams)->
        BlazeLayout.render 'masterLayout',
            main: "cms_home"