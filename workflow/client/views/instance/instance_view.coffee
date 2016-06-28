Template.instance_view.helpers
    instance: ->
        Session.get("change_date")
        if (Session.get("instanceId"))
            steedos_instance = WorkflowManager.getInstance();
            return steedos_instance;

    space_users: ->
        return db.space_users.find();

    unequals: (a,b) ->
        return !(a == b)

Template.instance_view.events
    'click .instance .form-control,.instance .suggestion-control,.instance .checkbox input,.instance .af-radio-group input,.instance .af-checkbox-group input': (event, template) ->
        console.log("click " + event.target.name);
        Session.set("instance_change", true);
    'change .ins-file-input': (event, template)->

            InstanceManager.uploadAttach(event.target.files, false)

            $(".ins-file-input").val('')

