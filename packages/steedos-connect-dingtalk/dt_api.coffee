# 获取套件访问Token（suite_access_token）
Dingtalk.suiteAccessTokenGet = (suite_key, suite_secret, suite_ticket) ->
  console.log '===Dingtalk.suiteAccessTokenGet==='
  console.log suite_key
  console.log suite_secret
  console.log suite_ticket
  try
    response = HTTP.post(
      "https://oapi.dingtalk.com/service/get_suite_token", 
      {
        data: 
          suite_key: suite_key,
          suite_secret: suite_secret,
          suite_ticket: suite_ticket
        headers: 
          "Content-Type": "application/json"
      }
    );
    console.log response
    if (response.error_code) 
      throw response.msg

    if response.data.errcode > 0 
      throw response.data.errmsg
    # {
    #     "suite_access_token":"61W3mEpU66027wgNZ_MhGHNQDHnFATkDa9-2llqrMBjUwxRSNPbVsMmyD-yq8wZETSoE5NQgecigDrSHkPtIYA",  
    #     "expires_in":7200
    # }
    return response.data

  catch err
    console.log err
    throw _.extend(new Error("Failed to complete OAuth handshake with Dingtalk. " + err), {response: err.response});

# 获取企业的永久授权码
Dingtalk.permanentCodeGet = (suite_access_token, tmp_auth_code) ->
  console.log '===Dingtalk.permanentCodeGet==='
  console.log suite_access_token
  console.log tmp_auth_code
  try
    response = HTTP.post(
      "https://oapi.dingtalk.com/service/get_permanent_code?suite_access_token="+suite_access_token, 
      {
        data: 
          tmp_auth_code: tmp_auth_code
        headers: 
          "Content-Type": "application/json"
      }
    );

    console.log response

    if (response.error_code) 
      throw response.msg

    if response.data.errcode > 0 
      throw response.data.errmsg
    # {
    #     "permanent_code": "xxxx",
    #     "auth_corp_info":
    #     {
    #         "corpid": "xxxx",
    #         "corp_name": "name"
    #     }
    # }
    return response.data

  catch err
    console.log err
    throw _.extend(new Error("Failed to complete OAuth handshake with Dingtalk. " + err), {response: err.response});

# 获取企业授权的access_token
Dingtalk.corpTokenGet = (suite_access_token, auth_corpid, permanent_code) ->
  console.log '===Dingtalk.corpTokenGet==='
  console.log suite_access_token
  console.log auth_corpid
  console.log permanent_code
  try
    response = HTTP.post(
      "https://oapi.dingtalk.com/service/get_corp_token?suite_access_token="+suite_access_token, 
      {
        data: 
          auth_corpid: auth_corpid,
          permanent_code: permanent_code
        headers: 
          "Content-Type": "application/json"
      }
    );

    if (response.error_code) 
      throw response.msg

    if response.data.errcode > 0 
      throw response.data.errmsg
    # {
    #     "access_token": "xxxxxx",
    #     "expires_in": 7200
    # }
    return response.data

  catch err
    throw _.extend(new Error("Failed to complete OAuth handshake with Dingtalk. " + err), {response: err.response});


# 激活授权套件
Dingtalk.activateSuitePost = (suite_access_token, suite_key, auth_corpid, permanent_code) ->
  console.log '===Dingtalk.activateSuitePost==='
  console.log suite_access_token
  console.log suite_key
  console.log auth_corpid
  console.log permanent_code
  try
    response = HTTP.post(
      "https://oapi.dingtalk.com/service/activate_suite?suite_access_token="+suite_access_token, 
      {
        data: 
          suite_key: suite_key,
          auth_corpid: auth_corpid,
          permanent_code: permanent_code
        headers: 
          "Content-Type": "application/json"
      }
    );

    if (response.error_code) 
      throw response.msg

    if response.data.errcode > 0 
      throw response.data.errmsg
    # {
    #     "errcode":0,
    #     "errmsg":"ok"
    # }
    return response.data

  catch err
    throw _.extend(new Error("Failed to complete OAuth handshake with Dingtalk. " + err), {response: err.response});


# 获取部门详情
Dingtalk.departmentGet = (access_token, department_id) ->
  console.log '===Dingtalk.departmentGet==='
  console.log access_token
  console.log department_id
  try
    response = HTTP.get(
      "https://oapi.dingtalk.com/department/get", 
      {
        params: 
          access_token: access_token,
          id: department_id
      }
    );

    if (response.error_code) 
      throw response.msg

    if response.data.errcode > 0 
      throw response.data.errmsg

    return response.data

  catch err
    throw _.extend(new Error("Failed to complete OAuth handshake with Dingtalk. " + err), {response: err.response});

# 获取部门列表
Dingtalk.departmentListGet = (access_token) ->
  console.log '===Dingtalk.departmentListGet==='
  console.log access_token
  try
    response = HTTP.get(
      "https://oapi.dingtalk.com/department/list", 
      {
        params: 
          access_token: access_token
      }
    );
    # console.log response
    if (response.error_code) 
      throw response.msg

    if response.data.errcode > 0 
      throw response.data.errmsg

    return response.data.department

  catch err
    throw _.extend(new Error("Failed to complete OAuth handshake with Dingtalk. " + err), {response: err.response});

# 获取部门成员（详情）
Dingtalk.userListGet = (access_token, department_id) ->
  console.log '===Dingtalk.userListGet==='
  console.log access_token
  console.log department_id
  try
    response = HTTP.get(
      "https://oapi.dingtalk.com/user/list", 
      {
        params: 
          access_token: access_token,
          department_id: department_id
      }
    );
    # console.log response
    if (response.error_code) 
      throw response.msg

    if response.data.errcode > 0 
      throw response.data.errmsg

    return response.data.userlist

  catch err
    throw _.extend(new Error("Failed to complete OAuth handshake with Dingtalk. " + err), {response: err.response});



Dingtalk.syncCompany = (access_token, auth_corp_info, permanent_code) ->
  console.log 'Dingtalk.syncCompany'
  console.log access_token
  console.log auth_corp_info
  console.log permanent_code

  now = new Date
  space_data = auth_corp_info
  org_data = Dingtalk.departmentListGet(access_token)

  # {
  #   "active": true,
  #   "avatar": "",
  #   "department": [
  #     1
  #   ],
  #   "dingId": "$:LWCP_v1:$YLZ+IpDaWyLxHEbw1vPL/Q==",
  #   "email": "",
  #   "isAdmin": false,
  #   "isBoss": false,
  #   "isHide": false,
  #   "isLeader": false,
  #   "jobnumber": "",
  #   "mobile": "15618031236",
  #   "name": "包 周 涛",
  #   "openId": "tZoZlV229tiP0klhbSEEsngiEiE",
  #   "order": 118693752662466672,
  #   "position": "",
  #   "remark": "",
  #   "tel": "",
  #   "userid": "04134717575889",
  #   "workPlace": ""
  # }
  user_data = []
  org_data.forEach (org) ->
    user_data = user_data.concat(Dingtalk.userListGet(access_token, org.id))

  owner_id = null
  admin_ids = []
  user_data.forEach (u) ->
    user_id = null
    uq = db.users.find({"services.dingtalk.id": u.dingId})
    if uq.count() > 0
      
      user = uq.fetch()[0]
      user_id = user._id
      doc = {}
      if user.name != u.name
        doc.name = u.name

      if user.avatarURL != u.avatar
        user.avatarURL = u.avatar

      if doc.hasOwnProperty('name') || doc.hasOwnProperty('avatarURL')
        console.log('修改用户: ' + u.name)
        console.log(doc)
        doc.modified = now
        db.users.direct.update(user_id, {$set: doc})
    else
      console.log('用户不存在')
      doc = {}
      doc._id = db.users._makeNewID()
      doc.steedos_id = doc._id
      doc.name = u.name
      doc.locale = "zh-cn"
      doc.is_deleted = false
      doc.created = now
      doc.modified = now
      doc.services = {dingtalk:{id: u.dingId}}
      doc.avatarURL = u.avatar
      console.log(doc)
      user_id = db.users.direct.insert(doc)

    if u.isBoss
      if !admin_ids.includes(user_id)
        admin_ids.push(user_id)
      owner_id = user_id
    else if u.isAdmin
      if !admin_ids.includes(user_id)
        admin_ids.push(user_id)
    
    u.user_id = user_id

  if !owner_id
    owner_id = admin_ids[0]

  # 新建工作区
  space_id = null
  s_id = "dt-" + space_data.corpid
  sq = db.spaces.find({_id: s_id})
  if sq.count() > 0
    space_id = s_id
    s = sq.fetch()[0]
    s_doc = {}
    if s.name != space_data.corp_name
      s_doc.name = space_data.corp_name

    if s.owner != owner_id
      s_doc.owner = owner_id

    if s.admins.sort().toString() != admin_ids.sort().toString()
      s_doc.admins = admin_ids

    if s_doc.hasOwnProperty('name') || s_doc.hasOwnProperty('owner') || s_doc.hasOwnProperty('admins')
      console.log('修改工作区')
      console.log(s_doc)
      s_doc.modified = now
      s_doc.modified_by = owner_id
    s_doc.services = { dingtalk:{ corp_id: space_data.corpid, access_token: access_token, permanent_code: permanent_code}}
    db.spaces.direct.update(space_id, {$set: s_doc})
  else
    console.log('新建工作区')

    s_doc = {}
    s_doc._id = s_id
    s_doc.name = space_data.corp_name
    s_doc.owner = owner_id
    s_doc.admins = admin_ids
    s_doc.is_deleted = false
    s_doc.created = now
    s_doc.created_by = owner_id
    s_doc.modified = now
    s_doc.modified_by = owner_id
    s_doc.services = { dingtalk:{ corp_id: space_data.corpid, access_token: access_token, permanent_code: permanent_code}}
    console.log(s_doc)
    space_id = db.spaces.direct.insert(s_doc)


  # 删除
  deleted_su_ids = []
  deleted_org_ids = []

  su_ids = []
  org_ids = []
  user_data.forEach (u) ->
    su_ids.push("dt-" + u.userid)

  org_data.forEach (o) ->
    org_ids.push("dt-" + space_data.corpid + "-" + o.id)

  db.space_users.find({space: space_id}).forEach (su) ->
    if !su_ids.includes(su._id)
      deleted_su_ids.push(su._id)

  db.organizations.find({space: space_id}).forEach (o) ->
    if !org_ids.includes(o._id)
      deleted_org_ids.push(o._id)

  db.space_users.find({_id: {$in: deleted_su_ids}}).forEach (su) ->
    console.log("删除space_user: " + su.name)
    db.space_users.direct.remove({_id: su._id})

    organizationObj = db.organizations.findOne(su.organization)
    organizationObj.updateUsers()

    # users_changelogs
    ucl_doc = {}
    ucl_doc.change_date = moment().format('YYYYMMDD')
    ucl_doc.operator = owner_id
    ucl_doc.space = space_id
    ucl_doc.operation = "delete"
    ucl_doc.user = su.user
    ucl_doc.created = now
    ucl_doc.created_by = owner_id

    count = db.space_users.direct.find({space: space_id}).count()
    ucl_doc.user_count = count
    db.users_changelogs.direct.insert(ucl_doc)

  db.organizations.find({_id: {$in: deleted_org_ids}}).forEach (o) ->
    console.log("删除部门: " + o.name)
    db.organizations.direct.remove({_id: o._id})


  # 新建部门
  Dingtalk.createOrg(org_data, undefined, space_id, space_data.corpid, owner_id)

  # 新建space_user
  user_data.forEach (u) ->
    su_id = "dt-" + u.userid
    suq = db.space_users.find({_id: su_id})
    if suq.count() == 0
      console.log('新建space_user')
      su_doc = {}
      su_doc._id = su_id
      su_doc.user = u.user_id
      su_doc.space = space_id
      su_doc.user_accepted = true
      su_doc.name = u.name
      su_doc.created = now
      su_doc.created_by = owner_id

      p_dept_id = null
      if u.department && u.department.length >0
        p_dept_id = u.department[0]
      if p_dept_id
        su_doc.organization = "dt-" + space_data.corpid + "-" + p_dept_id
      console.log(su_doc)
      space_user_id = db.space_users.direct.insert(su_doc)
      if space_user_id
        # update org users
        if su_doc.organization
          organizationObj = db.organizations.findOne(su_doc.organization)
          organizationObj.updateUsers()

        # users_changelogs
        ucl_doc = {}
        ucl_doc.change_date = moment().format('YYYYMMDD')
        ucl_doc.operator = owner_id
        ucl_doc.space = space_id
        ucl_doc.operation = "add"
        ucl_doc.user = u.user_id
        ucl_doc.created = now
        ucl_doc.created_by = owner_id

        count = db.space_users.direct.find({space: space_id}).count()
        ucl_doc.user_count = count
        console.log(ucl_doc)
        db.users_changelogs.direct.insert(ucl_doc)
    else if suq.count() > 0
      su = suq.fetch()[0]
      su_doc = {}
      if su.name != u.name
        su_doc.name = u.name

      p_dept_id = null
      if u.department && u.department.length >0
        p_dept_id = u.department[0]
      if p_dept_id
        new_org_id = "dt-" + space_data.corpid + "-" + p_dept_id
        
        if su.organization != new_org_id
          su_doc.organization = new_org_id

      if su_doc.hasOwnProperty('name') || su_doc.hasOwnProperty('organization')
        console.log('修改space_user')
        console.log su_doc
        r = db.space_users.direct.update(su._id, {$set: su_doc})
        console.log r
        if r && su_doc.organization
          organizationObj = db.organizations.findOne(su_doc.organization)
          organizationObj.updateUsers()
          old_org = db.organizations.findOne(su.organization)
          old_org.updateUsers()


  # 更新 org
  db.organizations.find({space: space_id}).forEach (org) ->
    console.log('更新部门 parents fullname children')
    updateFields = {}
    updateFields.parents = org.calculateParents()
    updateFields.fullname = org.calculateFullname()

    if !_.isEmpty(updateFields)
      db.organizations.direct.update(org._id, {$set: updateFields})

    if org.parent
      parent = db.organizations.findOne(org.parent)
      db.organizations.direct.update(parent._id, {$set: {children: parent.calculateChildren()}})

  # 模板表单和流程
  forms_count = db.forms.find({space: space_id}).count()
  if forms_count == 0
    root_org_query = db.organizations.find({space: space_id, is_company: true}, {fields: {_id: 1}})
    root_org = root_org_query.fetch()[0]
    if root_org
      db.spaces.createTemplateFormAndFlow(space_id)


Dingtalk.createOrg = (depts, parentid, space_id, company_id, owner_id) ->
  now = new Date
  orgs = depts.filter((d) -> 
            if d.parentid == parentid
              return true
          )
  if orgs.length > 0
    orgs.forEach (o) ->
      org_id = null
      o_id = "dt-" + company_id + "-" + o.id
      oq = db.organizations.find({_id: o_id})
      if oq.count() > 0
        org_id = o_id
        org = oq.fetch()[0]
        org_doc = {}
        if org.name != o.name
          org_doc.name = o.name

        if org_doc.hasOwnProperty('name')
          console.log('修改部门: ' + o.name)
          console.log(org_doc)
          org_doc.modified = now
          org_doc.modified_by = owner_id
          db.organizations.direct.update(org._id, {$set: org_doc})

      else
        console.log('新增部门')
        org_doc = {}
        org_doc._id = o_id
        org_doc.space = space_id
        org_doc.name = o.name
        if parentid >= 1
          org_doc.parent = "dt-" + company_id + "-" + parentid
        if o.id == 1
          org_doc.is_company = true
        org_doc.created = now
        org_doc.created_by = owner_id
        org_doc.modified = now
        org_doc.modified_by = owner_id
        console.log(org_doc)
        org_id = db.organizations.direct.insert(org_doc)
      if org_id
        Dingtalk.createOrg(depts, o.id, space_id, company_id, owner_id)





















