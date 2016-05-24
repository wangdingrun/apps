Template.instanceform.helpers
    instance: ->
        Session.get("change_date")
        if (Session.get("instanceId"))
            steedos_instance = WorkflowManager.getInstance();
            return steedos_instance;