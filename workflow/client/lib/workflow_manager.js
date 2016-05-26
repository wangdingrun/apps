WorkflowManager = {
  formVersionsCache: {},
  flowVersionsCache: {},
  instanceCache: null,
  instanceModified: new ReactiveVar(false)
};

/*-------------------data source------------------*/

WorkflowManager.getUrlForServiceName = function (serverName){
  var serverUrls = {"s3":"https://s3ws.steedos.com","workflow":"http://192.168.0.23"};
  return serverUrls[serverName];
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


//获取space下的所有用户
WorkflowManager.getSpaceUsers = function (spaceId){

  var users = new Array();
  
  var spaceUsers = db.space_users.find({}, {sort: {name:1}});

  spaceUsers.forEach(function(spaceUser){
    spaceUser.id = spaceUser.user;
    spaceUser.organization = WorkflowManager.getOrganization(spaceUser.organization);
    spaceUser.roles = WorkflowManager.getUserRoles(spaceId, spaceUser.organization.id, spaceUser.id);
    users.push(spaceUser);
    
  })

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

WorkflowManager.getSpaceRoles = function(spaceId){
  var roles = new Array();

  var spaceRoles = db.flow_roles.find();

  spaceRoles.forEach(function(spaceRole){
    spaceRole.id = spaceRole._id;
    roles.push(spaceRole);
  });

  return roles;
};

WorkflowManager.callInstanceDataMethod = function(instanceId, callback){

    instance = db.instances.findOne(instanceId);
    formCached = false
    flowCached = false

    if (instance){
      if (WorkflowManager.formVersionsCache[instance.form_version])
        formCached = true;
      if (WorkflowManager.flowVersionsCache[instance.flow_version])
        flowCached = true;
    }

    Meteor.call("get_instance_data", instanceId, formCached, flowCached, function(error, result){
      if (!result.instance) {
        // 服务端 instance 还没保存好。
        setTimeout(function(){
          WorkflowManager.callInstanceDataMethod(instanceId, callback);
        }, 300);
        return;
      }
      delete WorkflowManager["instanceCache"]
      WorkflowManager.instanceCache = result.instance;
      WorkflowManager.instanceModified.set(false);
      if (result.form_version){
        console.log("get form version " + result.form_version._id)
        WorkflowManager.formVersionsCache[result.form_version._id] = result.form_version
      }
      if (result.flow_version){
        console.log("get flow version " + result.flow_version._id)
        WorkflowManager.flowVersionsCache[result.flow_version._id] = result.flow_version
      }

      callback();

    });
}

WorkflowManager.getInstance = function (){
  return WorkflowManager.instanceCache
};


WorkflowManager.getInstanceFormVersion = function (){
  var form_fields = [],
      rev = null,
      instance = WorkflowManager.getInstance();

  if (instance) {

      rev = EJSON.clone(WorkflowManager.formVersionsCache[instance.form_version])

      field_permission = WorkflowManager.getInstanceFieldPermission();
      rev.fields.forEach(
        function(field){
          field['permission'] = field_permission[field.code] == 'editable' ? 'editable' : 'readonly';

          if (field.type == 'table'){
            field['sfields'] = field['fields']
            field['sfields'].forEach(function(sf){
              sf["permission"] = field_permission[field.code] == 'editable' ? 'editable' : 'readonly';
            });
            // 因为这个程序会傻傻的执行很多遍，所以不能删除
            delete field['fields']
          }

          if (field.type == 'section'){
            form_fields.push(field);
            if (field.fields){
              field.fields.forEach(function(f){
                f['permission'] = field_permission[field.code] == 'editable' ? 'editable' : 'readonly';
                form_fields.push(f);
              });
            }
          }else{
            form_fields.push(field);
          }
        }
      );

      rev.fields = form_fields;
  }

  return rev;
};

WorkflowManager.getInstanceFlowVersion = function (){
  instance = WorkflowManager.getInstance();
  if (instance){
      return EJSON.clone(WorkflowManager.flowVersionsCache[instance.flow_version])
  }
};

WorkflowManager.getInstanceFields = function(){
  var instanceForm = WorkflowManager.getInstanceFormVersion();

  return instanceForm.fields;
}

WorkflowManager.getInstanceStep = function(stepId){
  flow = WorkflowManager.getInstanceFlowVersion();

  if (!flow)
    return null;

  var g_step;

  flow.steps.forEach(
    function(step){
      if (step._id == stepId){
        g_step = step;
        g_step.id = step._id;
        return;
      }
    }
  );

  return g_step;
};

WorkflowManager.getInstanceSteps = function(){
  flow = WorkflowManager.getInstanceFlowVersion();

  if (!flow)
    return null;

  var steps = [];

  flow.steps.forEach(
    function(step){
      step.id = step._id;
      steps.push(step);
    }
  );

  return steps;
};

WorkflowManager.getInstanceFieldPermission = function (){
  instance = WorkflowManager.getInstance();

  if (!instance){
    return {};
  }

  var current_stepId = "";
  if(instance.traces){
    instance.traces.forEach(
      function(trace){
        if (trace.is_finished == false){
          current_stepId = trace.step;
          return;
        }
      }
    );
  }

 step = WorkflowManager.getInstanceStep(current_stepId);
 if (!step){
    return {}
 }
 //console.log("step.permissions is ")
 //console.log(step.permissions)
 return step.permissions || {};
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

WorkflowManager.getOrganization = function(orgId){

  if (!orgId) {
    return ;
  }

  var spaceOrg = db.organizations.findOne(orgId);

  spaceOrg.id = spaceOrg._id;

  return spaceOrg;
};

WorkflowManager.getOrganizations = function(orgIds){
  if(!orgIds){
    return [];
  }

  if("string" == typeof(orgIds)){
    return [WorkflowManager.getOrganization(orgIds)]
  }

  var orgs = new Array();
  orgIds.forEach(function(orgId){
    orgs.push(WorkflowManager.getOrganization(orgId));
  });
  return orgs;
};

WorkflowManager.getRoles = function(roleIds){
  if(!roleIds || !(roleIds instanceof Array)){
    return [];
  }

  var roles = new Array();

  roleIds.forEach(function(roleId){
    roles.push(WorkflowManager.getRole(roleId));
  });

  return roles;
}

WorkflowManager.getRole = function(roleId){
  
  if (!roleId) {
    return ;
  }

  var spaceRoles = WorkflowManager.getSpaceRoles(), role = {};

  spaceRoles.forEach(function(spaceRole){
    if(spaceRole.id == roleId){
      role = spaceRole;
      return ;
    }
  });

  return role;
};

WorkflowManager.getUser = function (userId){
  if (!userId) {
    return ;
  }

  if (typeof userId != "string"){

    return WorkflowManager.getUsers(userId);
  
  }

  var spaceUser = db.space_users.findOne({user:userId});

  spaceUser.id = spaceUser.user;
  spaceUser.organization = WorkflowManager.getOrganization(spaceUser.organization);
  spaceUser.roles = WorkflowManager.getUserRoles(Session.get("spaceId"), spaceUser.organization.id, spaceUser.id);
  
  return spaceUser;
};

WorkflowManager.getUsers = function (userIds){

  if("string" == typeof(userIds)){
    return [WorkflowManager.getUser(orgId)]
  }

  var users = new Array();
  if(userIds){
    var spaceUsers = WorkflowManager.getSpaceUsers("")
    spaceUsers.forEach(
      function(user){
          if (userIds.includes(user.id )){
            users.push(user);
          }
      }
    );
  }

  return users;
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

WorkflowManager.getRoleUsersByOrgsAndRoles = function(spaceId, orgIds, roleIds){
  var roleUsers = new Array();

  if (!orgIds || !roleIds)
    return roleUsers;

  orgIds.forEach(function(orgId){
    roleUsers = roleUsers.concat(WorkflowManager.getRoleUsersByOrgAndRoles(spaceId, orgId, roleIds));
  });

  return roleUsers;
};

/*
返回用户所在部门下的角色成员.
return [{spaceUser}]
*/
WorkflowManager.getRoleUsersByUsersAndRoles = function(spaceId, userIds, roleIds){

  var roleUsers = new Array();

  if (!userIds || !roleIds)
    return roleUsers;

  var users = WorkflowManager.getUsers(userIds);

  users.forEach(function(user){
    roleUsers = roleUsers.concat(WorkflowManager.getRoleUsersByOrgAndRoles(spaceId, user.organization.id, roleIds));
  });

  return roleUsers;
};

WorkflowManager.getFormulaUserObjects = function(userIds){
  if (!userIds)
    return ;
  if(userIds instanceof Array){
    var users = new Array();
    userIds.forEach(function(u){
      var user = WorkflowManager.getFormulaUserObject(u);
      if(u)
        users.push(user);
    });
    return users;
  }else{
    return WorkflowManager.getFormulaUserObject(userIds);
  }
}

//return {name:'',organization:{fullname:'',name:''},roles:[]}
WorkflowManager.getFormulaUserObject = function(userId){
  var userObject = {};

  var user = WorkflowManager.getUser(userId);

  if(!user || !user.hasOwnProperty("name"))
    return null;

  userObject['id'] = userId;
  userObject['name'] = user.name;
  userObject['organization'] = {'name':user.organization.name,'fullname':user.organization.fullname};
  userObject["roles"] = user.roles ? user.roles.getProperty('name'):[];

  return userObject;

};

WorkflowManager.getFormulaOrgObjects = function(orgIds){
  if (!orgIds)
    return ;
  if(orgIds instanceof Array){
    var orgs = new Array();
    orgIds.forEach(function(o){
      var org = WorkflowManager.getFormulaOrgObject(o);
      if(o)
        orgs.push(org);
    });
    return orgs;
  }else{
    return WorkflowManager.getFormulaOrgObject(orgIds);
  }
}

WorkflowManager.getFormulaOrgObject = function(orgId){
  var orgObject = {};

  var org = WorkflowManager.getOrganization(orgId);

  if(!org)
    return null;

  orgObject['id'] = orgId;
  orgObject['name'] = org.name;
  orgObject['fullname'] = org.fullname;

  return orgObject;
}

WorkflowManager.getSpaceCategories = function(spaceId){
  var re = new Array();

  var r = db.categories.find();

  r.forEach(function(c){
    re.push(c);
  });

  return re;
};

WorkflowManager.getSpaceFlows = function(spaceId){
  var re = new Array();

  var r = db.flows.find();

  r.forEach(function(c){
    re.push(c);
  });

  return re;
};

WorkflowManager.getSpaceForms = function(spaceId){
  var re = new Array();

  var r = db.forms.find();

  r.forEach(function(c){
    re.push(c);
  });

  return re;
};
