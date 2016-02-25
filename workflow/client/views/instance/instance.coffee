# if (steedos_form)
#	formula_fields = Form_formula.getFormulaFieldVariable("Form_formula.field_values", steedos_form.fields);

formId = 'instanceform';

Template.instanceform.helpers
	instanceId: ->
		return 'instanceform';#"instance_" + Session.get("instanceId");
	
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

	fields: ->
		form_version = WorkflowManager.getInstanceFormVersion();
		if form_version
			return new SimpleSchema(WorkflowManager_format.getAutoformSchema(form_version));
	doc_values: ->
		WorkflowManager_format.getAutoformSchemaValues();

	currentStep: ->
		return ApproveManager.getCurrentNextStep();



Template.instanceform.events
	
	'change .suggestion,.form-control': (event) ->
		instance = WorkflowManager.getInstance();
		currentStep = ApproveManager.getCurrentNextStep();
		form_version = WorkflowManager.getInstanceFormVersion();
		if !form_version
			return ;
		autoFormDoc = AutoForm.getFormValues("instanceform").insertDoc;
		nextSteps = ApproveManager.getNextSteps(instance, currentStep, event.target.value, autoFormDoc, form_version.fields);

		if !nextSteps
			return ;

		ApproveManager.updateNextStepOptions(nextSteps, event.target.value);

		if nextSteps.length ==1 || event.target.value == "rejected"
			nextStepId = $("#nextSteps option:selected").val();
			nextStepUsers = ApproveManager.getNextStepUsers(instance, nextStepId);
			ApproveManager.updateNextStepUsersOptions(nextStepUsers);

	'change #nextSteps': (event) ->
		instance = WorkflowManager.getInstance();
		nextStepId = $("#nextSteps option:selected").val();
		nextStepUsers = ApproveManager.getNextStepUsers(instance, nextStepId);
		ApproveManager.updateNextStepUsersOptions(nextStepUsers);

	'change .form-control': (event)->
		console.log("instanceform form-control change");
		code = event.target.name;
		form_version = WorkflowManager.getInstanceFormVersion();
		formula_fields = []
		if form_version
			formula_fields = Form_formula.getFormulaFieldVariable("Form_formula.field_values", form_version.fields);
		Form_formula.run(code, "", formula_fields, AutoForm.getFormValues("instanceform").insertDoc, form_version.fields);
	


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