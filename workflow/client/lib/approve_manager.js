ApproveManager = {};

ApproveManager.getCurrentNextStep = function(){

    var instance = WorkflowManager.getInstance();

    var currentTrace = instance.traces[instance.traces.length - 1];

    var currentStepId = currentTrace.step;

    return WorkflowManager.getInstanceStep(currentStepId);
}

ApproveManager.getNextSteps = function(instance, currentStep, judge){
    var nextSteps = new Array();
    var lines = currentStep.lines;

    switch(currentStep.step_type){
        case 'condition': //条件
            break;
        case 'end': //结束
            break;
        case 'sign': //审批
            if(judge == 'approved'){ //核准
                lines.forEach(function(line){
                    if(line.state == "approved"){
                        nextSteps.push(WorkflowManager.getInstanceStep(line.to_step));
                    }
                })
            }else if(judge=="rejected"){ //驳回
                lines.forEach(function(line){
                    if(line.state == "rejected"){
                        var rejected_step = WorkflowManager.getInstanceStep(line.to_step);
                        // 驳回时去除掉条件节点
                        if(rejected_step && rejected_step.step_type != "condition")
                            nextSteps.push(rejected_step);
                    }
                })

                var traces = instance.traces;

                traces.forEach(function(trace){
                    if(trace.is_finished == true){
                        var finished_step = WorkflowManager.getInstanceStep(trace.step);
                        if(finished_step.step_type != 'condition')
                            nextSteps.push(finished_step);
                    }
                });

            }
            break;
        default: //start：开始、submit：填写、counterSign：会签

            break;
    }

    nextSteps.sort(function(p1,p2){
        return p1.name.localeCompare(p2.name);
    });

    return nextSteps;
};

ApproveManager.getNextStepUsers = function(instance, nextStepId){
    var nextStepUsers = new Array();

    var nextStep = WorkflowManager.getInstanceStep(nextStepId);

    switch(nextStep.step_type){
        case 'condition':
            break;
        case 'start': //下一步步骤类型为开始
            nextStepUsers.push(WorkflowManager.getUser(instance.applicant));
            break;
        default:
            switch(nextStep.deal_type){
                case 'pickupAtRuntime': //审批时指定人员
                    nextStepUsers = WorkflowManager.getSpaceUsers(instance.space);
                    break;
                default:
                    break;
            }
            break;
    }

    return nextStepUsers;

};



ApproveManager.updateNextStepOptions = function(steps, judge){
    
    $("#nextSteps").empty();

    if(steps.length > 0 && judge == 'approved')
        $("#nextSteps").append("<option value='-1'> 请选择 </option>");

    steps.forEach(function(step){
        $("#nextSteps").append("<option value='" + step._id + "'> " + step.name + " </option>");
    });


};

ApproveManager.updateNextStepUsersOptions = function(users){
    $("#nextStepUsers").empty();

    users.forEach(function(user){
        $("#nextStepUsers").append("<option value='" + user._id + "'> " + user.name + " </option>");
    });

}