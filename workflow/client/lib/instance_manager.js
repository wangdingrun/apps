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
  if(message && message.length > 0){
    toastr.error(message);
  }
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
  var nextStepId = ApproveManager.getNextStepsSelectValue();
  var nextStep = WorkflowManager.getInstanceStep(nextStepId);
  
  if((value && value != '-1') || (nextStep && nextStep.step_type == 'end'))
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
          message = showMessage(parent_group, "字段‘" + field.name + '’为必填');
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
}

function adjustFieldValue(field,value){
  if(!value && value!=false){return value;}
  var adjustFieldTypes = ['number','multiSelect','radio','checkbox','dateTime','user','group'];

  if(adjustFieldTypes.includes(field.type)){
    switch(field.type){
      case 'number':
        value = value.toString();
        break;
      case 'multiSelect':
        value = value.toString();
        break;
      case 'radio':
        value = value.toString();
        break;
      case 'checkbox':
        value = value.toString();
        break;
      case 'dateTime':
        value = $.format.date(value,'yyyy-MM-ddTHH:mm');
        break;
      case 'group':
        value = WorkflowManager.getFormulaOrgObjects(value);
        break;
      case 'user':
        value = WorkflowManager.getFormulaUserObjects(value);
        break;
    }
  }
  return value;
}



InstanceManager.getInstanceValuesByAutoForm = function(){
  
  var fields = WorkflowManager.getInstanceFields();

  var instanceValue = InstanceManager.getCurrentValues();
  var autoFormValue = AutoForm.getFormValues("instanceform").insertDoc;

  var values = {};
  
  fields.forEach(function(field){
    if(field.type == 'table'){
      t_values = new Array();
      if (field.sfields){
        if (!autoFormValue[field.code])
          return ;
        autoFormValue[field.code].forEach(function(t_row_value){
          debugger;
          var is_invalid_tr = false;
          if(_.size(t_row_value) == 1){
            for(var k in t_row_value){
              if(t_row_value[k].toString() == 'false' || t_row_value[k].toString() == 'true'){
                is_invalid_tr = true;
              }
            }
          }
          if(!is_invalid_tr){
            field.sfields.forEach(function(sfield){
              //if(sfield.type == 'checkbox'){
              t_row_value[sfield.code] = adjustFieldValue(sfield, t_row_value[sfield.code]);
              //}
            });
            t_values.push(t_row_value);
          }
        });
      }
      values[field.code] = t_values;
    }else{
      if(field.type !='section'){
        values[field.code] = adjustFieldValue(field, autoFormValue[field.code]);
      }
    }
  });

  return values;
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

InstanceManager.getCurrentValues = function(){
  var instance = WorkflowManager.getInstance();
  var currentApprove = InstanceManager.getCurrentApprove();
  var approve_values_is_null = true;
  if(!currentApprove || !currentApprove.values){return;}
  if(_.size(currentApprove.values) != 0){
    approve_values_is_null = false;
  }

  var instanceValue = approve_values_is_null ? instance.values : currentApprove.values;

  return instanceValue;
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
        if(selectedNextStepUsers instanceof Array){
            selectedNextStepUsers.forEach(function(su){
              nextStepUsers.push(su.value);
            });
        }else{
            nextStepUsers.push(selectedNextStepUsers);
        }

        currentApprove.next_steps = [{step:nextStepId,users:nextStepUsers}];
    }

    currentApprove.values = InstanceManager.getInstanceValuesByAutoForm();

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
      Meteor.call("draft_save_instance", instance);
    } else if (state == "pending") {
      var myApprove = InstanceManager.getMyApprove();
      myApprove.values = InstanceManager.getInstanceValuesByAutoForm();
      Meteor.call("inbox_save_instance", myApprove);
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
  if (!instance)
    return;
  UUflow_api.delete_draft(instance._id);
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
      myApprove.values = InstanceManager.getInstanceValuesByAutoForm();
      UUflow_api.post_engine(myApprove);
    }
      
  }
}

// 取消申请
InstanceManager.terminateIns = function (reason) {
  var instance = WorkflowManager.getInstance();
  if (instance) {
    InstanceManager.resetId(instance);
    instance.terminate_reason = reason;
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

// 转签核
InstanceManager.reassignIns = function (user_ids, reason) {
  var instance = WorkflowManager.getInstance();
  if (instance) {
    InstanceManager.resetId(instance);
    instance.inbox_users = user_ids;
    instance.reassign_reason = reason;
    UUflow_api.put_reassign(instance);
  }
}

// 转签核
InstanceManager.relocateIns = function (step_id, user_ids, reason) {
  var instance = WorkflowManager.getInstance();
  if (instance) {
    InstanceManager.resetId(instance);
    instance.relocate_next_step = step_id;
    instance.relocate_inbox_users = user_ids;
    instance.relocate_comment = reason;
    UUflow_api.put_relocate(instance);
  }
}

// 归档
InstanceManager.archiveIns = function (insId) {
  var instance = db.instances.findOne(insId);
  if (instance) {
    if (instance.is_archived==true)
      return;
    UUflow_api.post_archive(insId);
  }
}

// 添加附件
InstanceManager.addAttach = function (fileObj) {
  var instance = db.instances.findOne(fileObj.metadata.instance);
  if (instance) {
    InstanceManager.resetId(instance);
    var state = instance.state;

    var curTime = new Date().toISOString();
    var userId = Meteor.userId();
    var fileName = fileObj.name();
    var attach = {
        "_id": Meteor.uuid(),
        "filename": fileName,
        "contentType": fileObj.type(),
        "modified": curTime,
        "modified_by": userId,
        "created": curTime,
        "created_by": userId,
        "current": {
          "_id": Meteor.uuid(),
          "_rev": fileObj._id,
          "length": fileObj.size(),
          "approve": InstanceManager.getMyApprove().id,
          "created": curTime,
          "created_by": userId,
          // "created_by_name": curUser.get('name'),
          "filename": fileName
        }
      };
    var attachs = instance.attachments;
    if (attachs) {
      attachs.push(attach);
    } else {
      attachs = [attach];
    }

    if (state == "draft") {
      instance.attachments = attachs;
      instance.traces[0].approves[0] = InstanceManager.getMyApprove();
      Meteor.call("draft_save_instance", instance);
    } else if (state == "pending") {
      var myApprove = InstanceManager.getMyApprove();
      myApprove.attachments = attachs;
      myApprove.values = InstanceManager.getInstanceValuesByAutoForm();
      Meteor.call("inbox_save_instance", myApprove);
    }
  }
}

// 移除附件
InstanceManager.removeAttach = function () {
  var instance = WorkflowManager.getInstance();
  if (instance) {
    InstanceManager.resetId(instance);
    var state = instance.state;
    var attachs = instance.attachments;
    var file_id = Session.get("file_id");
    var newAttachs = attachs.filter(function(item){
      if (item.current._rev != file_id)
        return item;
    })

    if (state == "draft") {
      instance.attachments = newAttachs;
      instance.traces[0].approves[0] = InstanceManager.getMyApprove();
      Meteor.call("draft_save_instance", instance);
    } else if (state == "pending") {
      var myApprove = InstanceManager.getMyApprove();
      myApprove.attachments = newAttachs;
      myApprove.values = InstanceManager.getInstanceValuesByAutoForm();
      Meteor.call("inbox_save_instance", myApprove);
    }
  }
}



