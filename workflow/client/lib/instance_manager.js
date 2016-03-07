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

InstanceManager.getFormFieldValue = function(fieldCode){
    return AutoForm.getFieldValue(fieldCode, "instanceform");
};

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
    var nextStepId = $("#nextSteps option:selected").val();
    if (nextStepId) {

        var selectedNextStepUsers = $("#nextStepUsers option:selected").toArray();
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



