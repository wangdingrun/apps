FlowRouter.notFound = 
    action: ()->
        BlazeLayout.render 'loginLayout',
            main: "not-found"


FlowRouter.route '/', 
    action: (params, queryParams)->
        if (!Meteor.userId())
            FlowRouter.go "/steedos/sign-in";
        else 
            FlowRouter.go "/steedos/springboard";
        

FlowRouter.route '/steedos', 
    action: (params, queryParams)->
        if !Meteor.userId()
            FlowRouter.go "/steedos/sign-in";
            return true
        else
            FlowRouter.go "/steedos/springboard";


FlowRouter.route '/steedos/logout', 
    action: (params, queryParams)->
        #AccountsTemplates.logout();
        Meteor.logout ()->
            Setup.logout();
            Session.set("spaceId", null);
            FlowRouter.go("/");


FlowRouter.route '/steedos/profile', 
    action: (params, queryParams)->
        if Meteor.userId()
            BlazeLayout.render 'adminLayout',
                main: "profile"


FlowRouter.route '/steedos/springboard', 
    action: (params, queryParams)->
        if !Meteor.userId()
            FlowRouter.go "/steedos/sign-in";
            return true

        BlazeLayout.render 'masterLayout',
            main: "springboard"


FlowRouter.route '/steedos/space', 
    action: (params, queryParams)->
        if !Meteor.userId()
            FlowRouter.go "/sign-in";
            return true

        BlazeLayout.render 'loginLayout',
            main: "space_select"


