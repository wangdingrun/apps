Template.instance_button.helpers
    enabled_submit: ->
        ins = WorkflowManager.getInstance();
        if !ins
            return;
        flow = db.flows.findOne(ins.flow);
        if !flow
            return;

        if (Session.get("box")=="draft"&&flow.state=="enabled") || Session.get("box")=="inbox"
            return "";
        else
            return "display: none;";

    enabled_save: ->
        ins = WorkflowManager.getInstance();
        if !ins
            return;
        flow = db.flows.findOne(ins.flow);
        if !flow
            return;

        if (Session.get("box")=="draft"&&flow.state=="enabled") || Session.get("box")=="inbox"
            return "";
        else
            return "display: none;";

    enabled_delete: ->
        # TODO 流程管理员
        ins = WorkflowManager.getInstance();
        if !ins
            return;
        space = db.spaces.findOne(ins.space);
        if !space
            return;

        if Session.get("box")=="draft" || (Session.get("box")=="monitor" && space.admins.contains(Meteor.userId()))
            return "";
        else
            return "display: none;";

    enabled_print: ->
        # TODO 手机打印
        if Meteor.isCordova
            return "display: none;";
        else
            return "";


    enabled_add_attachment: -> 
        if Session.get("box")=="draft" || Session.get("box")=="inbox"
            return "";
        else
            return "display: none;";

    enabled_terminate: ->
        ins = WorkflowManager.getInstance();
        if !ins
            return;
        if (Session.get("box")=="pending" || Session.get("box")=="inbox") && ins.state=="pending" && ins.applicant==Meteor.userId()
            return "";
        else
            return "display: none;";

    enabled_reassign: -> 
        # TODO 流程管理员
        ins = WorkflowManager.getInstance();
        if !ins
            return;
        space = db.spaces.findOne(ins.space);
        if !space
            return;

        if Session.get("box")=="monitor" && ins.state=="pending" && space.admins.contains(Meteor.userId())
            return "";
        else
            return "display: none;";

    enabled_relocate: -> 
        # TODO 流程管理员
        ins = WorkflowManager.getInstance();
        if !ins
            return;
        space = db.spaces.findOne(ins.space);
        if !space
            return;

        if Session.get("box")=="monitor" && ins.state=="pending" && space.admins.contains(Meteor.userId())
            return "";
        else
            return "display: none;";

Template.instance_button.events
    'click #instance_back': (event)->
        backURL =  "/space/" + Session.get("spaceId") + "/" + Session.get("box")
        FlowRouter.go(backURL)

    'click #instance_to_print': (event)->
        UUflow_api.print($("#instanceId").val());


    'click #instance_update': (event)->
        InstanceManager.saveIns();

    'click #instance_remove': (event)->
        InstanceManager.deleteIns();

    'click #instance_submit': (event)->
        InstanceManager.checkFormValue();
        if($(".has-error").length == 0)
            InstanceManager.submitIns();

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

    