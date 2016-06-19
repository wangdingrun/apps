@NavigationController = 
    routes: [],
    go: (routeName)->
        this.routes.push(FlowRouter.current().path)
        FlowRouter.go(routeName)
    back: (routeName) ->
        routeName = this.routes.pop()
        if routeName
            FlowRouter.go(routeName)
        else
            FlowRouter.go "/"


