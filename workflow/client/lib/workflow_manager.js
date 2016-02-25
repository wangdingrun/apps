WorkflowManager = {};

WorkflowManager.getInstance = function (){
  instanceId = Session.get("instanceId");
  return db.instances.findOne(instanceId)
};

WorkflowManager.getInstanceFormVersion = function (){
 
  var form_fields = [];

  var rev = null

  instanceId = Session.get("instanceId");
  instance = db.instances.findOne(instanceId);
  if (instance) {
    form = db.forms.findOne(instance.form);
    if (form){
      rev = form.current;
      field_permission = WorkflowManager.getInstanceFieldPermission();
      rev.fields.forEach(
        function(field){
          field['permission'] = field_permission[field.code] == 'editable' ? 'editable' : 'readonly';

          if (field.type == 'table'){
            field['sfields'] = field['fields']
            delete field['fields']
          }
          if (field.type == 'section'){
            form_fields.push(field);
            if (field.fields){
              form_fields = form_fields.concat(field.fields);
            }
          }else{
            form_fields.push(field);
          }
        }
      );

      rev.fields = form_fields;
    } 
  }

  return rev;
};

WorkflowManager.getInstanceFields = function(){
  var instanceForm = WorkflowManager.getInstanceFormVersion();

  return instanceForm.fields;
}

WorkflowManager.getInstanceFlowVersion = function (){
  instanceId = Session.get("instanceId");
  instance = db.instances.findOne(instanceId);
  if (instance){
    flow = db.flows.findOne(instance.flow);
    if (flow)
      return flow.current;
  }
};


WorkflowManager.getInstanceStep = function(stepId){
  flow = WorkflowManager.getInstanceFlowVersion();

  if (!flow)
    return null;

  var g_step;

  flow.steps.forEach(
    function(step){
      if (step._id == stepId){
        g_step = step;
        return;
      }
    }
  );

  return g_step;
};

WorkflowManager.getInstanceFieldPermission = function (){
  instance = WorkflowManager.getInstance();

  if (!instance){
    return {}
  }

  var current_stepId = "";

  instance.traces.forEach(
    function(trace){
      if (trace.is_finished == false){
        current_stepId = trace.step;
        return;
      }
    }
  );

 step = WorkflowManager.getInstanceStep(current_stepId);
 if (!step){
    return {}
 }
 //console.log("step.permissions is ")
 //console.log(step.permissions)
 return step.permissions;
};

WorkflowManager.getUrlForServiceName = function (serverName){
  var serverUrls = {"s3":"https://s3ws.steedos.com"};
  return serverUrls[serverName];
};

WorkflowManager.getForm = function (formId){
  return db.forms.findOne(formId);
};

WorkflowManager.getFlow = function (flowId){
	return db.flows.findOne(flowId);
};
//获取space下的所有部门
WorkflowManager.getSpaceOrganizations = function (spaceId){
  var orgs = new Array();
  var spaceOrgs = db.organizations.find();

  spaceOrgs.forEach(function(spaceOrg){
    spaceOrg.id = spaceOrg._id
    orgs.push(spaceOrg);
  })

  return orgs;
};



WorkflowManager.getOrganizationChildrens = function(spaceId, orgId){
  var spaceOrganizations = WorkflowManager.getSpaceOrganizations(spaceId);
  var chidrenOrgs= spaceOrganizations.filterProperty("parents", orgId);

  return chidrenOrgs;
};

WorkflowManager.getOrganizationsChildrens = function(spaceId, orgIds){
  var chidrenOrgs = new Array();
  orgIds.forEach(function(orgId){
    chidrenOrgs = chidrenOrgs.concat(WorkflowManager.getOrganizationChildrens(spaceId, orgId));
  });

  return chidrenOrgs;
};

WorkflowManager.getOrganizationsUsers = function(spaceId, orgs){

  var spaceUsers = WorkflowManager.getSpaceUsers(spaceId);

  var orgUsers = new Array();

  orgs.forEach(function(org){
    orgUsers = orgUsers.concat(WorkflowManager.getUsers(org.users));
  });

  return orgUsers;
}

//获取space下的所有用户
WorkflowManager.getSpaceUsers = function (spaceId){
  
  var users = new Array();

  // for(var i = 0 ; i < 15 ; i++){
    
  //   var userObject = new Object();
  //   userObject.id = i + "56fdsfsd8f79s8df7s8fsdfusdi";
  //   userObject.steedos_id = i + "baozhoutao@hotoa.com";
  //   userObject.name = i + "包周涛";
  //   userObject.organization = WorkflowManager.getUserOrganization(spaceId, userObject.id);
  //   userObject.roles = WorkflowManager.getUserRoles(spaceId, userObject.id);

  //   users.push(userObject);
  // }

  var spaceUsers = db.space_users.find();

  spaceUsers.forEach(function(spaceUser){
    spaceUser.id = spaceUser.user;
    spaceUser.organization = WorkflowManager.getOrganization(spaceUser.organization);
    spaceUser.roles = WorkflowManager.getUserRoles(spaceId, spaceUser.organization.id, spaceUser.id);
    users.push(spaceUser);
  })

  return users;

};

WorkflowManager.getUser = function (userId){

  if (!userId) {
    return {name:''};
  }

  if (typeof userId != "string"){

    return WorkflowManager.getUsers(userId);
  
  }

  var spaceUsers = WorkflowManager.getSpaceUsers("") , spaceUser = {};

  spaceUsers.forEach(
    function(user){
        if (user.id == userId){
          spaceUser = user;
          return ;
        }
    }
  );

  return spaceUser;
};

WorkflowManager.getUsers = function (userIds){

  var users = new Array();

  if(userIds){
    userIds.forEach(function(userId){
      users.push(WorkflowManager.getUser(userId));
    });
  }

  return users;
};

WorkflowManager.getSpacePositions = function(spaceId){
  var positions = new Array();

  var spacePositions = db.flow_positions.find();

  spacePositions.forEach(function(spacePosition){
    positions.push(spacePosition);
  });

  return positions;
};

//获取用户岗位
WorkflowManager.getUserRoles = function(spaceId, orgId, userId){

  var userRoles = new Array();

  var spacePositions = WorkflowManager.getSpacePositions(spaceId);

  //orgRoles = spacePositions.filterProperty("org", orgId);
  var userPositions = spacePositions.filterProperty("users", userId);

  userPositions.forEach(function(userPosition){
    userRoles.push(WorkflowManager.getRole(userPosition.role));
  });

  return userRoles;
};

WorkflowManager.getSpaceRoles = function(spaceId){
  var roles = new Array();

  var spaceRoles = db.flow_roles.find();

  spaceRoles.forEach(function(spaceRole){
    spaceRole.id = spaceRole._id;
    roles.push(spaceRole);
  });

  return roles;
};

WorkflowManager.getRole = function(roleId){
  
  if (!roleId) {
    return {name:''};
  }

  var spaceRoles = WorkflowManager.getSpaceRoles(), role = {};

  spaceRoles.forEach(function(spaceRole){
    if(spaceRoles.id = roleId){
      role = spaceRole;
      return ;
    }
  });

  return role;
};

/*
返回指定部门下的角色成员,如果指定部门没有找到对应的角色，则会继续找部门的上级部门直到找到为止。
return [{spaceUser}]
*/
WorkflowManager.getRoleUsersbyOrgAndRole = function(spaceId, orgId, roleId){

  var roleUsers = new Array();

  var spaceRoles = WorkflowManager.getSpaceRoles(spaceId);

  var spacePositions = WorkflowManager.getSpacePositions(spaceId);

  var rolePositions = spacePositions.filterProperty("role", roleId);

  var orgPositions = rolePositions.filterProperty("org", orgId);

  orgPositions.forEach(function(orgPosition){
    var roleUserIds = orgPosition.users;
    roleUsers = roleUsers.concat(WorkflowManager.getUsers(roleUserIds));
  });

  if(orgPositions.length == 0){
    var organization = WorkflowManager.getOrganization(orgId);
    if(organization.parent != '')
      roleUsers = roleUsers.concat(WorkflowManager.getRoleUsersbyOrgAndRole(spaceId, organization.parent, roleId));
  }

  return roleUsers;
};

WorkflowManager.getRoleUsersByOrgAndRoles = function(spaceId, orgId, roleIds){

  var roleUsers = new Array();

  roleIds.forEach(function(roleId){
    roleUsers = roleUsers.concat(WorkflowManager.getRoleUsersbyOrgAndRole(spaceId, orgId, roleId));
  });

  return roleUsers;

};


WorkflowManager.getOrganization = function(orgId){

  if (!orgId) {
    return {name:''};
  }

  var spaceOrgs = WorkflowManager.getSpaceOrganizations("") , spaceOrg = {};

  spaceOrgs.forEach(
    function(org){
        if (org.id == orgId){
          spaceOrg = org;
          return ;
        }
    }
  );

  return spaceOrg;
};

WorkflowManager.getOrganizations = function(orgIds){
  if(!orgIds || !(orgIds instanceof Array)){
    return [];
  }

  var orgs = new Array();
  orgIds.forEach(function(orgId){
    orgs.push(WorkflowManager.getOrganization(orgId));
  });
  return orgs;
};



//return {name:'',organization:{fullname:'',name:''},roles:[]}
WorkflowManager.getFormulaUserObject = function(userId){
  userObject = {};

  userObject['name'] = 'test';
  userObject['organization'] = {fullname:'test organization fullname', name:'test organization name'};
  userObject["roles"] = ['role1','role2','role3'];

  return userObject;

};
