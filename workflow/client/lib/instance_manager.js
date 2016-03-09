InstanceManager = {};

InstanceManager.getFormField = function(fieldId){
    var instanceFields = WorkflowManager.getInstanceFields();
    var field = instanceFields.filterProperty("_id", fieldId);

    if (field.length > 0){
        return field[0];
    }

    return null;
}

InstanceManager.getApplicantUserId = function(){
  var instance = WorkflowManager.getInstance();
  if(instance)
    return instance.applicant;
  return '';
}

function showMessage(parent_group,message){
  parent_group.addClass("has-error");
  $(".help-block",parent_group).html(message);
}

function removeMessage(parent_group){
  parent_group.removeClass("has-error");
  $(".help-block",parent_group).html('');
}

InstanceManager.checkFormValue = function(){
  
  InstanceManager.checkNextStep();

  InstanceManager.checkNextStepUser();

  InstanceManager.checkSuggestion();

  //字段校验
  var fieldsPermision = WorkflowManager.getInstanceFieldPermission();

  for(var k in fieldsPermision){
    if(fieldsPermision[k] == 'editable'){
      InstanceManager.checkFormFieldValue($("[name='"+k+"']")[0]);
    }
  }
}

//下一步步骤校验
InstanceManager.checkNextStep = function(){
  var nextSteps_parent_group = $("#nextSteps").parent();

  if(ApproveManager.error.nextSteps != ''){
    showMessage(nextSteps_parent_group, ApproveManager.error.nextSteps);
    ApproveManager.error.nextSteps = '';
    return ;
  }

  var value = ApproveManager.getNextStepsSelectValue();
  if(value && value != '-1')
    removeMessage(nextSteps_parent_group);
  else
    showMessage(nextSteps_parent_group, '请选择下一步步骤');
}

//下一步处理人校验
InstanceManager.checkNextStepUser = function(){
  var nextStepUsers_parent_group = $("#nextStepUsers").parent();

  if(ApproveManager.error.nextStepUsers != ''){
    showMessage(nextStepUsers_parent_group, ApproveManager.error.nextStepUsers);
    ApproveManager.error.nextStepUsers = '';
    return ;
  }
  var value = ApproveManager.getNextStepUsersSelectValue();
  if(value && value != '-1')
    removeMessage(nextStepUsers_parent_group);
  else
    showMessage(nextStepUsers_parent_group, '请选择下一步处理人');
}

//如果是驳回必须填写意见
InstanceManager.checkSuggestion = function(){
  var judge = $("[name='judge']").filter(':checked').val();
  var suggestion_parent_group = $("#suggestion").parent();
  if(judge && judge == 'rejected'){
    if($("#suggestion").val())
      removeMessage(suggestion_parent_group);
    else
      showMessage(suggestion_parent_group, '驳回时必须填写意见');
  }else{
    removeMessage(suggestion_parent_group);
  }
}

InstanceManager.checkFormFieldValue = function(field){

    if(!field)
      return ;

    var reg_email = /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/;
    var parent_group = $("#" + field.id).parent();
    var message = '';
    if(field.required){
      if(!field.value || field.value == '' || field.length < 1)
          message = showMessage(parent_group, '此字段为必填');
    }

    if(field.type == 'email' && field.value !=''){
        if(!reg_email.test(field.value))
          message = '邮件地址格式错误';
    }

    if(message=='')
      removeMessage(parent_group);
    else
      showMessage(parent_group, message);
}

InstanceManager.getFormFieldValue = function(fieldCode){
    return AutoForm.getFieldValue(fieldCode, "instanceform");
};

InstanceManager.getInstanceValuesByAutoForm = function(){
  var adjustFieldType = ['number','date-time','checked','user','groups']
}

InstanceManager.resetId = function (instance) {
  instance.id = instance._id;
  delete instance._id;
  instance.traces.forEach(function(t){
    t.id = t._id;
    delete t._id;
    if (t.approves) {
      t.approves.forEach(function(a){
        a.id = a._id;
        delete a.id;
      })
    }
  })
}

InstanceManager.getCurrentStep = function(){

    var instance = WorkflowManager.getInstance();

    if(!instance || !instance.traces)
        return ;

    var currentTrace = instance.traces[instance.traces.length - 1];

    var currentStepId = currentTrace.step;

    return WorkflowManager.getInstanceStep(currentStepId);
}

InstanceManager.getCurrentApprove = function(){
  var instance = WorkflowManager.getInstance();

  if (!instance)
    return ;

  if (!instance.traces || instance.traces.length < 1)
    return ;

  var currentTraces = instance.traces.filterProperty("is_finished", false);

  if(currentTraces.length < 1)
    return ;

  var currentApproves = currentTraces[0].approves.filterProperty("user", localStorage.getItem("Meteor.userId"));
  
  var currentApprove = currentApproves.length > 0 ? currentApproves[0] : null;
  
  if (!currentApprove)
    return ;

  currentApprove.id = currentApprove._id;
  delete currentApprove._id;
  return currentApprove; 
}

InstanceManager.getMyApprove = function(){

  var currentApprove = InstanceManager.getCurrentApprove();

  if(currentApprove){
    currentApprove.description = $("#suggestion").val();
    var judge = $("[name='judge']").filter(':checked').val();
    if (judge)
        currentApprove.judge = judge;
    var nextStepId = ApproveManager.getNextStepsSelectValue();
    if (nextStepId) {

        var selectedNextStepUsers = ApproveManager.getNextStepUsersSelectValue();
        var nextStepUsers = new Array();
        selectedNextStepUsers.forEach(function(su){
          nextStepUsers.push(su.value);
        });
        currentApprove.next_steps = [{step:nextStepId,users:nextStepUsers}];
    }

    currentApprove.values = AutoForm.getFormValues("instanceform").insertDoc;

    return currentApprove;
  }

  return {};
}

// 申请单暂存
InstanceManager.saveIns = function() {
  var instance = WorkflowManager.getInstance();
  if (instance) {
    InstanceManager.resetId(instance);
    var state = instance.state;
    if (state == "draft") {
      instance.traces[0].approves[0] = InstanceManager.getMyApprove();
      UUflow_api.put_draft(instance);
    } else if (state == "pending") {
      var myApprove = InstanceManager.getMyApprove();
      myApprove.values = AutoForm.getFormValues("instanceform").insertDoc;
      UUflow_api.put_approvals(myApprove);
    }
  }
}

// 申请单新建
InstanceManager.newIns = function(flowId) {
  UUflow_api.post_draft(flowId);
}

// 申请单删除
InstanceManager.deleteIns = function() {
  var instance = WorkflowManager.getInstance();
  if (instance && instance.state == "draft") {
    UUflow_api.delete_draft(instance._id);
  }
  
}

// 申请单提交
InstanceManager.submitIns = function() {
  var instance = WorkflowManager.getInstance();
  if (instance) {
    InstanceManager.resetId(instance);
    var state = instance.state;
    if (state=="draft") {
      instance.traces[0].approves[0] = InstanceManager.getMyApprove();
      UUflow_api.post_submit(instance);
    } else if (state=="pending") {
      var myApprove = InstanceManager.getMyApprove();
      myApprove.values = AutoForm.getFormValues("instanceform").insertDoc;
      UUflow_api.post_engine(myApprove);
    }
      
  }
}

// 取消申请
InstanceManager.terminateIns = function (terminate_reason) {
  var instance = WorkflowManager.getInstance();
  if (instance) {
    InstanceManager.resetId(instance);
    instance.terminate_reason = terminate_reason;
    UUflow_api.post_terminate(instance);
  }
}

// 导出报表
InstanceManager.exportIns = function (type) {
  spaceId = Session.get("spaceId");
  flowId = Session.get("flowId");
  if (spaceId && flowId)
    UUflow_api.get_export(spaceId, flowId, type);
}



