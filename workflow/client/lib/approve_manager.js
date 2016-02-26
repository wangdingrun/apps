ApproveManager = {};

ApproveManager.getCurrentNextStep = function(){

    var instance = WorkflowManager.getInstance();

    if(!instance || !instance.traces)
        return ;

    var currentTrace = instance.traces[instance.traces.length - 1];

    var currentStepId = currentTrace.step;

    return WorkflowManager.getInstanceStep(currentStepId);
}

ApproveManager.getNextSteps = function(instance, currentStep, judge, autoFormDoc, fields){

    if(!currentStep)
        return ;

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
    nextSteps = nextSteps.uniqById();

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
    rev_nextSteps = rev_nextSteps.uniqById();

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

    var applicant = WorkflowManager.getUser(instance.applicant);

    switch(nextStep.step_type){
        case 'condition':
            break;
        case 'start': //下一步步骤类型为开始
            nextStepUsers.push(applicant);
            break;
        default:
            switch(nextStep.deal_type){
                case 'pickupAtRuntime': //审批时指定人员
                    nextStepUsers = WorkflowManager.getSpaceUsers(instance.space);
                    break;
                case 'specifyUser': //指定人员
                    var specifyUserIds = nextStep.approver_users;
                    nextStepUsers = nextStepUsers.concat(WorkflowManager.getUsers(specifyUserIds));
                    break;
                case 'applicantRole': //指定审批岗位
                    var approveRoles = nextStep.approver_roles;
                    nextStepUsers = WorkflowManager.getRoleUsersByOrgAndRoles(instance.space, applicant.organization.id, approveRoles);
                    if(nextStepUsers.length < 1){
                        //todo 记录未找到角色人员的原因，用于前台显示
                        console.error("步骤: " + nextStep.name + "找指定岗位处理人失败。参数：orgId is " + applicant.organization.id + ";roleIds is " + approveRoles);
                    }
                    break;
                case 'applicantSuperior': //申请人上级
                    nextStepUsers = WorkflowManager.getUsers(applicant.managers);
                    break;
                case 'applicant': //申请人
                    nextStepUsers.push(applicant);
                    break;
                case 'userField': //指定人员字段
                    var userFieldId =  nextStep.approver_user_field;
                    var userField = InstanceManager.getFormField(userFieldId);
                    if(userField){
                        var userFieldValue = InstanceManager.getFormFieldValue(userField.code);
                        if(userField.is_multiselect){ //如果多选，以userFieldValue值为Array
                            nextStepUsers = WorkflowManager.getUsers(userFieldValue);
                        }else{
                            nextStepUsers.push(WorkflowManager.getUser(userFieldValue));
                        }
                    }
                    if(nextStepUsers.length < 1){
                       //todo 记录记录未找到的原因，用于前台显示 
                       console.error("步骤: " + nextStep.name + "fieldId is " + fieldId);
                    }
                    break;
                case 'orgField': //指定部门字段
                    var orgFieldId = nextStep.approver_org_field;
                    var orgField = InstanceManager.getFormField(orgFieldId);

                    if(orgField){
                        var orgFieldValue = InstanceManager.getFormFieldValue(orgField.code);

                        var orgs;

                        var orgChildrens = new Array();

                        //获得orgFieldValue的所有子部门
                        if(orgField.is_multiselect){//如果多选，以orgFieldValue值为Array
                            orgs = WorkflowManager.getOrganizations(orgFieldValue);
                            orgChildrens = WorkflowManager.getOrganizationsChildrens(instance.space, orgFieldValue);
                        }else{
                            orgs = [WorkflowManager.getOrganization(orgFieldValue)];
                            orgChildrens = WorkflowManager.getOrganizationChildrens(instance.space, orgFieldValue);
                        }

                        nextStepUsers = WorkflowManager.getOrganizationsUsers(instance.space, orgChildrens);
                        
                        orgFieldUsers = WorkflowManager.getOrganizationsUsers(instance.space, orgs);

                        nextStepUsers = nextStepUsers.concat(orgFieldUsers);
                    }

                    if(nextStepUsers < 1){
                        //todo 记录记录未找到的原因，用于前台显示 
                    }
                    break;
                case 'specifyOrg': //指定部门
                    var specifyOrgIds = nextStep.approver_orgs;

                    var specifyOrgs = WorkflowManager.getOrganizations(specifyOrgIds);
                    var specifyOrgChildrens = WorkflowManager.getOrganizationsChildrens(instance.space,specifyOrgIds);

                    nextStepUsers = WorkflowManager.getOrganizationsUsers(instance.space, specifyOrgs);
                    nextStepUsers = nextStepUsers.concat(WorkflowManager.getOrganizationsUsers(instance.space, specifyOrgChildrens));
                    if(nextStepUsers < 1){
                        //todo 记录记录未找到的原因，用于前台显示 
                    }
                    break;
                case 'userFieldRole': //指定人员字段相关审批岗位

                    var approverRoles = nextStep.approver_roles;
                    var userFieldId = nextStep.approver_user_field;
                    var userField = InstanceManager.getFormField(userFieldId);

                    if (userField){
                        var userFieldValue = InstanceManager.getFormFieldValue(userField.code);

                        if(userField.is_multiselect){//如果多选，以userFieldValue值为Array
                            nextStepUsers = WorkflowManager.getRoleUsersByUsersAndRoles(instance.space, userFieldValue, approverRoles);
                        }else{
                            nextStepUsers = WorkflowManager.getRoleUsersByUsersAndRoles(instance.space, [userFieldValue], approverRoles);
                        }
                    }

                    if(nextStepUsers < 1){
                        //todo 记录记录未找到的原因，用于前台显示 
                    }

                    break;
                case 'orgFieldRole': //指定部门字段相关审批岗位
                    var approverRoles = nextStep.approver_roles;
                    var orgFieldId = nextStep.approver_org_field;
                    var orgField = InstanceManager.getFormField(orgFieldId);

                    if(orgField){
                        var orgFieldValue = InstanceManager.getFormFieldValue(orgField.code);

                        if(orgField.is_multiselect){//如果多选，以orgFieldValue值为Array
                            nextStepUsers = WorkflowManager.getRoleUsersByOrgsAndRoles(instance.space, orgFieldValue, approverRoles);
                        }else{
                            nextStepUsers = WorkflowManager.getRoleUsersByOrgsAndRoles(instance.space, [orgFieldValue], approverRoles);
                        }
                    }

                    if(nextStepUsers < 1){
                        //todo 记录记录未找到的原因，用于前台显示 
                    }

                    break;
                default:
                    break;
            }
            break;
    }

    nextStepUsers = nextStepUsers.uniqById();

    //按照步骤名称排序(升序)
    nextStepUsers.sort(function(p1,p2){
        return p1.name.localeCompare(p2.name);
    });

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

    if(steps.length > 1)
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

    if(users.length > 1 ){
        $("#nextStepUsers").prepend("<option value='-1'> 请选择 </option>");
        $("#nextStepUsers").get(0).selectedIndex = 0;
    }

}