# if (steedos_form)
#   formula_fields = Form_formula.getFormulaFieldVariable("Form_formula.field_values", steedos_form.fields);

formId = 'instanceform';

Template.instanceform.helpers
    applicantContext: ->
        steedos_instance = WorkflowManager.getInstance();
        data = {name:'ins_applicant',atts:{name:'ins_applicant',id:'ins_applicant',class:'selectUser form-control',style:'padding:6px 12px;width:25%;display:inline'}} 
        if not steedos_instance || steedos_instance.state != "draft"
            data.atts.disabled = true
        return data;
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
        Session.get("change_date")
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

    suggestion_box_style: ->
        judge = Session.get("judge")
        if judge
            if (judge == "approved")
                return "box-success" 
            else if (judge == "rejected")
                return "box-danger"

    instance_box_style: ->
        box = Session.get("box")
        if box == "inbox" || box == "draft"
            return
        ins = WorkflowManager.getInstance();
        if ins && ins.final_decision
            if ins.final_decision == "approved"
                return "box-success" 
            else if (ins.final_decision == "rejected")
                return "box-danger"

    is_disabled: ->
        ins = WorkflowManager.getInstance();
        if !ins
            return;
        if ins.state!="draft"
            return "disabled";
        return;

    judge: ->

        currentApprove = InstanceManager.getCurrentApprove();
        if !Session.get("judge")
             Session.set("judge", currentApprove.judge);

        if !Session.get("judge")
            currentStep = InstanceManager.getCurrentStep();
            # 默认核准
            if (currentStep.step_type == "sign" || currentStep.step_type == "counterSign")
                Session.set("judge", "approved");
                
        currentApprove.judge = Session.get("judge");

        return Session.get("judge")

    next_step_options: ->
        form_values = Session.get("form_values")
        return InstanceManager.getNextStepOptions();

    #next_user_options: ->
    #    console.log("next_user_options run ...");
    #    return InstanceManager.getNextUserOptions();

    next_user_context: ->
        console.log("next_user_context run ...");
        form_values = Session.get("form_values")
        users = InstanceManager.getNextUserOptions();

        data = {dataset:{},name:'nextStepUsers',atts:{name:'nextStepUsers',id:'nextStepUsers',class:'selectUser nextStepUsers form-control',style:'padding:6px 12px;'}};
        
        next_user = $("input[name='nextStepUsers']");
        
        
        selectedUser = [];


        users.forEach (user) ->
            if user.selected 
                selectedUser.push(user);

        if users.length == 1 && selectedUser.length < 1 
            selectedUser = [users[0]];
        

        if next_user && next_user.length > 0
            if !Session.get("next_step_users_showOrg")
                next_user[0].dataset.userOptions = users.getProperty("id")
                next_user[0].dataset.showOrg = false;
            else
                delete next_user[0].dataset.userOptions
                delete next_user[0].dataset.showOrg
            
            next_user[0].dataset.multiple = Session.get("next_user_multiple");
            
            next_userIds = []
            next_userIdObjs = []
            if next_user[0].value!=""
                next_userIds = next_user[0].dataset.values.split(",");
                next_userIdObjs = users.filterProperty("id",next_userIds)

            if next_userIds.length > 0 && next_userIdObjs.length > 0 && next_userIds.length = next_userIdObjs.length
                next_user[0].value = next_userIdObjs.getProperty("name").toString();
                next_user[0].dataset.values = next_userIdObjs.getProperty("id").toString();
                data.value = next_user[0].value;
                data.dataset['values'] = next_user[0].dataset.values;
            else
                next_user[0].value = selectedUser.getProperty("name").toString();
                next_user[0].dataset.values = selectedUser.getProperty("id").toString()
                data.value = next_user[0].value
                data.dataset['values'] = selectedUser.getProperty("id").toString()
        else
            
            if !Session.get("next_step_users_showOrg")
                data.dataset['userOptions']= users.getProperty("id")
                data.dataset['showOrg'] = false;

            data.dataset['multiple'] = Session.get("next_user_multiple");

            data.value = selectedUser
            data.dataset['values'] = selectedUser.getProperty("id").toString()



        return data;

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

    #t.subscribe "instance_data", Session.get("instanceId"), ->
    #    Tracker.afterFlush -> 
    instance = WorkflowManager.getInstance();
    if !instance
        return;

    #$("#ins_applicant").select2().val(instance.applicant).trigger('change');
    #$("#ins_applicant").val(instance.applicant);
    $("input[name='ins_applicant']")[0].dataset.values = instance.applicant;
    $("input[name='ins_applicant']").val(instance.applicant_name)
    

    ApproveManager.error = {nextSteps:'',nextStepUsers:''};
    if !ApproveManager.isReadOnly()
        currentApprove = InstanceManager.getCurrentApprove();

        judge = currentApprove.judge
        currentStep = InstanceManager.getCurrentStep();
        form_version = WorkflowManager.getInstanceFormVersion();

        Form_formula.initFormScripts(form_version.form_script);

        formula_fields = Form_formula.getFormulaFieldVariable("Form_formula.field_values", form_version.fields);
        Form_formula.run("", "", formula_fields, AutoForm.getFormValues("instanceform").insertDoc, form_version.fields);
        #在此处初始化session 中的 form_values 变量，用于触发下一步步骤计算
        Session.set("form_values", AutoForm.getFormValues("instanceform").insertDoc);

Template.instanceform.events
    
    'change .suggestion': (event) ->
        console.log("change .suggestion");
        if ApproveManager.isReadOnly()
            return ;
        judge = $("[name='judge']").filter(':checked').val();
        Session.set("judge", judge);

    'change .nextSteps': (event) ->
        if event.target.name == 'nextSteps'
            if $("#nextSteps").find("option:selected").attr("steptype") == 'counterSign'
                Session.set("next_user_multiple", true)
            else
                Session.set("next_user_multiple", false)
            Session.set("next_step_id",$("#nextSteps").val())
        

    'change #suggestion': (event) ->
        console.log("change #suggestion");
        if ApproveManager.isReadOnly()
            return ;
        InstanceManager.checkSuggestion();  

    'change .instance-form .form-control': (event)->
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
        Session.set("form_values", AutoForm.getFormValues("instanceform").insertDoc);
        #InstanceManager.updateNextStepTagOptions();
        
    
    
        

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

    
                     
               
           





