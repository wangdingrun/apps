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
    init_formScripts: ->
        form_version = WorkflowManager.getInstanceFormVersion();
        if form_version
            Form_formula.initFormScripts(form_version.form_script);

    init_nextStepsOptions: ->
        console.log("run init_nextStepsOptions...");
        #将下一步、处理人控件设置为select2
        if ApproveManager.isReadOnly()
            return ;
        
        $("#nextSteps").select2();
        $("#nextStepUsers").select2();
        $("#ins_applicant").select2();

        currentApprove = InstanceManager.getCurrentApprove();
        if !currentApprove
            return;

        if(currentApprove.next_steps.length < 1)
            return ;

        judge = currentApprove.judge
        instance = WorkflowManager.getInstance();
        currentStep = InstanceManager.getCurrentStep();
        form_version = WorkflowManager.getInstanceFormVersion();
        if !form_version
            return ;
        autoFormDoc = AutoForm.getFormValues("instanceform").insertDoc;
        nextSteps = ApproveManager.getNextSteps(instance, currentStep, judge, autoFormDoc, form_version.fields);

        if !nextSteps
            return ;

        ApproveManager.updateNextStepOptions(nextSteps, judge);

        nextStepId = currentApprove.next_steps[0].step;
        if nextSteps.filterProperty('id',nextStepId).length > 0
            if $("#nextSteps").get(0)
                $("#nextSteps").get(0).value = nextStepId;
        else
            return ;

        nextStepUsers = ApproveManager.getNextStepUsers(instance, nextStepId);
        nextStep = WorkflowManager.getInstanceStep(nextStepId);
        ApproveManager.updateNextStepUsersOptions(nextStep, nextStepUsers);
        #设置选中的用户
        u_ops = $("#nextStepUsers option").toArray();

        if u_ops.length > 0
            if $("#nextStepUsers").get(0)
                $("#nextStepUsers").get(0).selectedIndex = -1;

        u_op.selected = true for u_op in u_ops when currentApprove.next_steps[0].users.includes(u_op.value)

        $("#ins_applicant").select2().val(instance.applicant);
        $("#ins_applicant").select2().val();
        

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



Template.instanceform.events
    
    'change .suggestion,.form-control': (event) ->
        if ApproveManager.isReadOnly()
            return ;
        judge = $("[name='judge']").filter(':checked').val();
        instance = WorkflowManager.getInstance();
        currentStep = InstanceManager.getCurrentStep();
        form_version = WorkflowManager.getInstanceFormVersion();
        if !form_version
            return ;
        autoFormDoc = AutoForm.getFormValues("instanceform").insertDoc;
        nextSteps = ApproveManager.getNextSteps(instance, currentStep, judge, autoFormDoc, form_version.fields);

        if !nextSteps
            $("#nextSteps").empty();$("#nextStepUsers").empty();
            return;

        ApproveManager.updateNextStepOptions(nextSteps, judge);

        if nextSteps.length ==1 || judge == "rejected"
            nextStepId = ApproveManager.getNextStepsSelectValue();
            nextStepUsers = ApproveManager.getNextStepUsers(instance, nextStepId);
            nextStep = WorkflowManager.getInstanceStep(nextStepId);
            ApproveManager.updateNextStepUsersOptions(nextStep, nextStepUsers);
        else
            $("#nextStepUsers").empty();

        InstanceManager.checkSuggestion();
        InstanceManager.checkNextStep();
        InstanceManager.checkNextStepUser();

    'change #suggestion': (event) ->
        if ApproveManager.isReadOnly()
            return ;
        InstanceManager.checkSuggestion();
        
    'change #nextSteps': (event) ->
        if ApproveManager.isReadOnly()
            return ;
        instance = WorkflowManager.getInstance();
        nextStepId = ApproveManager.getNextStepsSelectValue();
        nextStep = WorkflowManager.getInstanceStep(nextStepId);

        nextStepUsers = ApproveManager.getNextStepUsers(instance, nextStepId);
        ApproveManager.updateNextStepUsersOptions(nextStep, nextStepUsers);

        InstanceManager.checkNextStep();
        InstanceManager.checkNextStepUser();

    'change #nextStepUsers': (event) ->
        if ApproveManager.isReadOnly()
            return ;
        InstanceManager.checkNextStepUser();

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
           console.log(JSON.stringify(AutoForm.getFormValues("instanceform").insertDoc));
           Form_formula.run(code, "", formula_fields, AutoForm.getFormValues("instanceform").insertDoc, form_version.fields);
        ,101

    'change .ins-file-input': (event, template)->
        FS.Utility.eachFile(event, (file) ->
            $('#upload_progress_bar').modal('show');
            newFile = new FS.File(file);
            currentApprove = InstanceManager.getCurrentApprove();
            newFile.metadata = {owner:Meteor.userId(), space:Session.get("spaceId"), instance:Session.get("instanceId"), approve: currentApprove.id};
            cfs.instances.insert(newFile, (err,fileObj) -> 
                if err
                    toastr.error(err);
                else
                    Session.set("progress_file_id", fileObj._id);
                    fileObj.on("uploaded", ()->
                            InstanceManager.addAttach(fileObj, false);
                            fileObj.removeListener("uploaded");
                        )
                )
            )





