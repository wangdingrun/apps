ApproveManager = {};

ApproveManager.getCurrentNextStep = function(){

    var instance = WorkflowManager.getInstance();

    var currentTrace = instance.traces[instance.traces.length - 1];

    var currentStepId = currentTrace.step;

    return WorkflowManager.getInstanceStep(currentStepId);
}

ApproveManager.getNextSteps = function(instance, currentStep, judge, autoFormDoc, fields){
    var nextSteps = new Array();
    var lines = currentStep.lines;

    switch(currentStep.step_type){
        case 'condition': //条件
            nextSteps = Form_formula.getNextStepsFromCondition(currentStep, autoFormDoc, fields);
            break;
        case 'end': //结束
            return next_steps;
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
            lines.forEach(function(line){
                if(line.state == "submitted"){
                    var submitted_step = WorkflowManager.getInstanceStep(line.to_step);
                    if(submitted_step)
                        nextSteps.push(submitted_step);
                }
            });
            break;
    }

    //去除重复
    nextSteps = nextSteps.uniq();

    //按照步骤名称排序(升序)
    nextSteps.sort(function(p1,p2){
        return p1.name.localeCompare(p2.name);
    });

    var condition_next_steps = new Array();
    nextSteps.forEach(function(nextStep){
        if(nextStep.step_type == "condition"){
            condition_next_steps = condition_next_steps.concat(ApproveManager.getNextSteps(instance, nextStep, judge, autoFormDoc, fields));
        }
    })

    nextSteps = nextSteps.concat(condition_next_steps);

    var rev_nextSteps = new Array();

    nextSteps.forEach(function(nextStep){
        if(nextStep.step_type != "condition")
            rev_nextSteps.push(nextStep);
    });


    //去除重复
    rev_nextSteps = rev_nextSteps.uniq();

    // 会签节点，如果下一步有多个 则清空下一步
    if (currentStep.step_type == "counterSign" && rev_nextSteps.length > 1){
        rev_nextSteps = [];
    }

    return rev_nextSteps;
};

ApproveManager.getNextStepUsers = function(instance, nextStepId){
    var nextStepUsers = new Array();

    var nextStep = WorkflowManager.getInstanceStep(nextStepId);

    if (!nextStep)
        return ;

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
    
    $("#nextStepUsers").empty();

    if(!steps)
        return;
    
    steps.forEach(function(step){
        $("#nextSteps").append("<option value='" + step._id + "'> " + step.name + " </option>");
    });

    if(steps.length > 1 && judge == 'approved')
        $("#nextSteps").prepend("<option value='-1'> 请选择 </option>");

    if(steps.length > 0)
        $("#nextSteps").get(0).selectedIndex = 0;

};

ApproveManager.updateNextStepUsersOptions = function(users){
    
    $("#nextStepUsers").empty();
    
    if(!users)
        return;

    users.forEach(function(user){
        $("#nextStepUsers").append("<option value='" + user._id + "'> " + user.name + " </option>");
    });

}