# if (steedos_form)
#   formula_fields = Form_formula.getFormulaFieldVariable("Form_formula.field_values", steedos_form.fields);

formId = 'instanceform';

Template.instanceform.helpers
    instanceId: ->
        return 'instanceform';#"instance_" + Session.get("instanceId");

    form_types: ->
        if ApproveManager.isReadOnly()
            return 'disabled';
        else
            return 'method';
    
    steedos_form: ->
        form_version = WorkflowManager.getInstanceFormVersion();
        if form_version
            return form_version

    innersubformContext: (obj)->
        doc_values = WorkflowManager_format.getAutoformSchemaValues();;
        obj["tableValues"] = if doc_values then doc_values[obj.code] else []
        obj["formId"] = formId;
        return obj;

    instance: ->
        if (Session.get("instanceId"))
            steedos_instance = WorkflowManager.getInstance();
            return steedos_instance;

    equals: (a,b) ->
        return (a == b)

    includes: (a, b) ->
        return b.split(',').includes(a);

    fields: ->
        form_version = WorkflowManager.getInstanceFormVersion();
        if form_version
            return new SimpleSchema(WorkflowManager_format.getAutoformSchema(form_version));
    doc_values: ->
        WorkflowManager_format.getAutoformSchemaValues();

    currentStep: ->
        return InstanceManager.getCurrentStep();

    currentApprove: ->
        return InstanceManager.getCurrentApprove();

    show_suggestion: ->

        return !ApproveManager.isReadOnly();

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

    space_users: ->
        return db.space_users.find();

    is_disabled: ->
        ins = WorkflowManager.getInstance();
        if !ins
            return;
        if ins.state!="draft"
            return "disabled";
        return;

    next_step_options: ->
        console.log("calculate next_step_options")
        if ApproveManager.isReadOnly()
            return []

        instance = WorkflowManager.getInstance();
        currentApprove = InstanceManager.getCurrentApprove();
        current_next_steps = currentApprove.next_steps;

        if Session.get("judge")
            judge = Session.get("judge")
        else
            judge = currentApprove.judge
        currentStep = InstanceManager.getCurrentStep();
        form_version = WorkflowManager.getInstanceFormVersion();
        # 待办：获取表单值
        autoFormDoc = {} #AutoForm.getFormValues("instanceform").insertDoc;
        nextSteps = ApproveManager.getNextSteps(instance, currentStep, judge, autoFormDoc, form_version.fields);

        next_step_options = []
        if nextSteps && nextSteps.length > 0
            next_step_id = null;
            next_step_type = null
            nextSteps.forEach (step)->
                option = {
                    id: step.id,
                    text: step.name
                    type: step.step_type
                }
                if current_next_steps && current_next_steps.length > 0
                    if current_next_steps[0].step == step.id
                        option.selected = true
                        next_step_id = step.id
                        next_step_type = step.step_type

                next_step_options.push(option)
            # 默认选中第一个
            if not next_step_id and next_step_options.length>0
                next_step_options[0].selected = true
                next_step_id = next_step_options[0].id
                next_step_type = next_step_options[0].step_type

            Session.set("next_step_id", next_step_id);
            #触发selecte2重新加载
            Session.set("next_step_multiple", false)
            if next_step_id
                if(next_step_type == 'counterSign')
                    Session.set("next_user_multiple", true)
                else
                    Session.set("next_user_multiple", false)

        return next_step_options;

    next_user_options: ->

        console.log("calculate next_user_options")

        next_user_options = []

        next_step_id = Session.get("next_step_id");
        next_user_multiple = Session.get("next_user_multiple")
        if next_step_id

            instance = WorkflowManager.getInstance();
            currentApprove = InstanceManager.getCurrentApprove();
            current_next_steps = currentApprove.next_steps;
            
            nextStepUsers = ApproveManager.getNextStepUsers(instance, next_step_id);
            next_user_ids = [];
            nextStepUsers.forEach (user)->
                option = {
                    id: user.id,
                    text: user.name
                }
                if current_next_steps && current_next_steps.length > 0
                    if _.contains(current_next_steps[0].users, user.id)
                        option.selected = true
                        next_user_ids.push(user.id)
                next_user_options.push(option)

            if next_user_options.length == 1
                next_user_options[0].selected = true
                next_user_ids.push(next_user_options[0].id)


        return next_user_options;

    next_step_multiple: ->
        Session.get("next_step_multiple")

    next_user_multiple: ->
        Session.get("next_user_multiple")

    attachments: ->
        # instance 修改时重算
        WorkflowManager.instanceModified.get();
        
        instance = WorkflowManager.getInstance();
        return instance.attachments;

Template.instanceform.onRendered ->
    t = this;

    t.$("#ins_applicant").select2();

    #t.subscribe "instance_data", Session.get("instanceId"), ->
    #    Tracker.afterFlush -> 
    instance = WorkflowManager.getInstance();
    if !instance
        return;

    $("#ins_applicant").select2().val(instance.applicant).trigger('change');

    ApproveManager.error = {nextSteps:'',nextStepUsers:''};

    if !ApproveManager.isReadOnly()
        currentApprove = InstanceManager.getCurrentApprove();

        judge = currentApprove.judge
        currentStep = InstanceManager.getCurrentStep();
        form_version = WorkflowManager.getInstanceFormVersion();
        # 默认核准
        if (currentStep.step_type == "sign" || currentStep.step_type == "sign") && !judge
            $("#judge_approved").prop("checked", "checked").trigger("change");

        Form_formula.initFormScripts(form_version.form_script);

Template.instanceform.events
    
    'change .suggestion,.form-control': (event) ->
        console.log("change .suggestion,.form-control");
        if ApproveManager.isReadOnly()
            return ;
        judge = $("[name='judge']").filter(':checked').val();
        Session.set("judge", judge);

    'change #suggestion': (event) ->
        console.log("change #suggestion");
        if ApproveManager.isReadOnly()
            return ;
        InstanceManager.checkSuggestion();
        

    'change .form-control': (event)->
        if ApproveManager.isReadOnly()
            return ;
        
        code = event.target.name;

        console.log("instanceform form-control change, code is " + code);

        InstanceManager.checkFormFieldValue(event.target);

        form_version = WorkflowManager.getInstanceFormVersion();
        formula_fields = []
        if form_version
            formula_fields = Form_formula.getFormulaFieldVariable("Form_formula.field_values", form_version.fields);
        Form_formula.run(code, "", formula_fields, AutoForm.getFormValues("instanceform").insertDoc, form_version.fields);
    
    
    'click #instance_back': (event)->
        backURL =  "/workflow/" + Session.get("box") + "/" + Session.get("spaceId")
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
        

    # 子表删除行时，执行主表公式计算
    'click .remove-steedos-table-row': (event, template)->
        console.log("instanceform form-control change");
        code = event.target.name;

        form_version = WorkflowManager.getInstanceFormVersion();
        formula_fields = []
        if form_version
            formula_fields = Form_formula.getFormulaFieldVariable("Form_formula.field_values", form_version.fields);

        # autoform-inputs 中 markChanged 函数中，对template 的更新延迟了100毫秒，
        # 此处为了能拿到删除列后最新的数据，此处等待markChanged执行完成后，再进行计算公式.
        # 此处给定等待101毫秒,只是为了将函数添加到 Timer线程中，并且排在markChanged函数之后。

        setTimeout ->
           Form_formula.run(code, "", formula_fields, AutoForm.getFormValues("instanceform").insertDoc, form_version.fields);
        ,101

    'change .ins-file-input': (event, template)->
        $(document.body).addClass("loading");
        $('.loading-text').text "正在上传..."
        FS.Utility.eachFile event, (file) ->
            if file.name
                $('.loading-text').text "正在上传..." + file.name
                        
            newFile = new FS.File(file);
            currentApprove = InstanceManager.getCurrentApprove();
            newFile.metadata = {owner:Meteor.userId(), space:Session.get("spaceId"), instance:Session.get("instanceId"), approve: currentApprove.id};
            cfs.instances.insert newFile, (err,fileObj) -> 
                if err
                    toastr.error(err);
                else
                    Session.set("progress_file_id", fileObj._id);
                    #$('.loading-text').text fileObj.uploadProgress() + "%"
                    fileObj.on "uploaded", ()->
                        $(document.body).removeClass("loading");
                        $('.loading-text').text ""
                        InstanceManager.addAttach(fileObj, false);
                     
               
           





