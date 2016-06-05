FlowRouter.route '/springboard', 
    action: (params, queryParams)->
        if !Meteor.userId()
            FlowRouter.go "/sign-in";
            return true

        BlazeLayout.render 'masterLayout',
            main: "springboard"
