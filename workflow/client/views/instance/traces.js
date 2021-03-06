
var formatStr = "yyyy-MM-dd HH:mm";

Template.instance_traces.helpers({

  equals: function(a,b) {
    return a === b;
  },

  empty: function(a){
    if (a)
        return a.toString().trim().length < 1;
    else
        return true;
  },
  unempty: function(a){
    if (a)
        return a.toString().trim().length > 0;
    else
        return false;
  },

  append: function(a,b) {
    return a + b ;
  },

  dateFormat: function(date){
    return $.format.date(new Date(date), formatStr);
  },

  getStepName: function(stepId){
    var step =WorkflowManager.getInstanceStep(stepId);
    if (step)
      return step.name;

    return null;
  },

  getApproveStatusIcon:function(approveJudge){
    //已结束的显示为核准/驳回/取消申请，并显示处理状态图标
    var approveStatusIcon;

    switch(approveJudge){
        case 'approved':
            approveStatusIcon = 'ion ion-checkmark-round';
            break;
        case 'rejected':
            approveStatusIcon = 'ion ion-close-round';
            break;
        case 'terminated':
            approveStatusIcon = '';
            break;
        case 'reassigned':
            approveStatusIcon = 'ion ion-android-contact';
            break;
        case 'relocated':
            approveStatusIcon = 'ion ion-arrow-shrink';
            break;
        default:
            approveStatusIcon = '';
            break;
    }
    return approveStatusIcon;
  },

  getApproveStatusText: function(approveJudge){
    //已结束的显示为核准/驳回/取消申请，并显示处理状态图标
    var approveStatusText;

    switch(approveJudge){
        case 'approved':
            approveStatusText = TAPi18n.__('Instance State approved');
            break;
        case 'rejected':
            approveStatusText = TAPi18n.__('Instance State rejected');
            break;
        case 'terminated':
            approveStatusText = TAPi18n.__('Instance State terminated');
            break;
        case 'reassigned':
            approveStatusText = TAPi18n.__('Instance State reassigned');
            break;
        case 'relocated':
            approveStatusText = TAPi18n.__('Instance State relocated');
            break;
        default:
            approveStatusText = "";
            break;
    }
    return approveStatusText;
  }

});