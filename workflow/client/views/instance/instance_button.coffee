Template.instance_button.helpers
    enabled_submit: ->
        ins = WorkflowManager.getInstance();
        if !ins
            return "display: none;";
        flow = db.flows.findOne(ins.flow);
        if !flow
            return "display: none;";

        if (Session.get("box")=="draft"&&flow.state=="enabled") || Session.get("box")=="inbox"
            return "";
        else
            return "display: none;";

    enabled_save: ->
        ins = WorkflowManager.getInstance();
        if !ins
            return "display: none;";
        flow = db.flows.findOne(ins.flow);
        if !flow
            return "display: none;";

        if (Session.get("box")=="draft"&&flow.state=="enabled") || Session.get("box")=="inbox"
            return "";
        else
            return "display: none;";

    enabled_delete: ->
        # TODO 流程管理员
        ins = WorkflowManager.getInstance();
        if !ins
            return "display: none;";
        space = db.spaces.findOne(ins.space);
        if !space
            return "display: none;";

        if Session.get("box")=="draft" || (Session.get("box")=="monitor" && space.admins.contains(Meteor.userId()))
            return "";
        else
            return "display: none;";

    enabled_print: ->
        # TODO 手机打印
        return "";


    enabled_add_attachment: -> 
        if Session.get("box")=="draft" || Session.get("box")=="inbox"
            return "";
        else
            return "display: none;";

    enabled_terminate: ->
        ins = WorkflowManager.getInstance();
        if !ins
            return "display: none;";
        if (Session.get("box")=="pending" || Session.get("box")=="inbox") && ins.state=="pending" && ins.applicant==Meteor.userId()
            return "";
        else
            return "display: none;";

    enabled_reassign: -> 
        # TODO 流程管理员
        ins = WorkflowManager.getInstance();
        if !ins
            return "display: none;";
        space = db.spaces.findOne(ins.space);
        if !space
            return "display: none;";

        if Session.get("box")=="monitor" && ins.state=="pending" && space.admins.contains(Meteor.userId())
            return "";
        else
            return "display: none;";

    enabled_relocate: -> 
        # TODO 流程管理员
        ins = WorkflowManager.getInstance();
        if !ins
            return "display: none;";
        space = db.spaces.findOne(ins.space);
        if !space
            return "display: none;";

        if Session.get("box")=="monitor" && ins.state=="pending" && space.admins.contains(Meteor.userId())
            return "";
        else
            return "display: none;";

Template.instance_button.events
    'click #instance_back': (event)->
        backURL =  "/workflow/space/" + Session.get("spaceId") + "/" + Session.get("box")
        FlowRouter.go(backURL)

    'click #instance_to_print': (event)->
        UUflow_api.print(Session.get("instanceId"));


    'click #instance_update': (event)->
        InstanceManager.saveIns();
        Session.set("instance_change", false);

    'click #instance_remove': (event)->
        swal {   
            title: t("Are you sure?"),    
            type: "warning",   
            showCancelButton: true,  
            cancelButtonText: t('Cancel'), 
            confirmButtonColor: "#DD6B55",   
            confirmButtonText: t('OK'),   
            closeOnConfirm: true 
        }, () ->  
            InstanceManager.deleteIns()

    'click #instance_submit': (event)->
        InstanceManager.checkFormValue();
        if($(".has-error").length == 0)
            InstanceManager.submitIns();
            Session.set("instance_change", false);

    'click #instance_force_end': (event)->
        swal {
            title: "取消申请", 
            text: "请输入取消申请的理由", 
            type: "input",
            confirmButtonText: t('OK'),
            cancelButtonText: t('Cancel'),
            showCancelButton: true,
            closeOnConfirm: false
        }, (reason) ->
            # 用户选择取消
            if (reason == false) 
                return false;

            if (reason == "") 
                swal.showInputError("请输入取消申请的理由");
                return false;
            
            InstanceManager.terminateIns(reason);
            sweetAlert.close();

    'click #instance_reassign': (event, template) ->
        Modal.show('reassign_modal')

    'click #instance_relocate': (event, template) ->
        Modal.show('relocate_modal')

    