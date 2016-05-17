# BQQ.app =
#   app_id: "200626779",
#   app_secret: "UkQ6G6gFJwJBfYuv"


BQQ.company =      
  company_id: 'c4609934c326caf9fd0053823bb99947',
  company_token: '07ded6f5c4c31706018434f88a94b461',
  refresh_token: '8cfbcf279c61028750ad5bcec13d8b03',


config = ServiceConfiguration.configurations.findOne({service: 'bqq'});

BQQ.corporationGet = ()->
  try
    response = HTTP.get(
      "https://openapi.b.qq.com/api/corporation/get", 
      {
        params: 
          app_id: config.clientId,
          app_secret: OAuth.openSecret(config.secret),
          company_id: BQQ.company.company_id,
          company_token: BQQ.company.company_token,
          client_ip: "0.0.0.0",
          oauth_version: 2
        
      }
    );

    console.log(response);
    if (response.error_code) 
      throw response.msg

    if response.data.ret > 0 
      throw response.data.msg

    return response.data.data

  catch err
    throw _.extend(new Error("Failed to complete OAuth handshake with QQ. " + err.message), {response: err.response});


BQQ.deptGet = ()->
  try
    response = HTTP.get(
      "https://openapi.b.qq.com/api/dept/list", 
      {
        params: 
          app_id: config.clientId,
          company_id: BQQ.company.company_id,
          company_token: BQQ.company.company_token,
          client_ip: "0.0.0.0",
          oauth_version: 2,
          timestamp: 0
        
      }
    );

    if (response.error_code) 
      throw response.msg

    if response.data.ret > 0 
      throw response.data.msg

    return response.data.data

  catch err
    throw _.extend(new Error("Failed to complete OAuth handshake with QQ. " + err.message), {response: err.response});


BQQ.userGet = ()->
  try
    response = HTTP.get(
      "https://openapi.b.qq.com/api/user/list", 
      {
        params: 
          app_id: config.clientId,
          company_id: BQQ.company.company_id,
          company_token: BQQ.company.company_token,
          client_ip: "0.0.0.0",
          oauth_version: 2,
          timestamp: 0
        
      }
    );

    console.log(JSON.stringify(response));
    if (response.error_code) 
      throw response.msg

    if response.data.ret > 0 
      throw response.data.msg

    return response.data.data

  catch err
    throw _.extend(new Error("Failed to complete OAuth handshake with QQ. " + err.message), {response: err.response});

# BQQ.syncCompany({ expires_in: 7776000,refresh_token: '8cfbcf279c61028750ad5bcec13d8b03',company_id: 'c4609934c326caf9fd0053823bb99947',company_token: '07ded6f5c4c31706018434f88a94b461' })
BQQ.syncCompany = (oauth) ->
  BQQ.company = oauth

  now = new Date
  # 工作区
  # {
  #   "company_id": "000a3d937971d3675423bccfc53798a1",
  #   "company_name": "Test_lucy_标准",
  #   "company_fullname": "测试_johnnyliu",
  #   "company_duedate": "1970-01-01"
  # }
  space_data = BQQ.corporationGet()
  console.log(JSON.stringify(space_data))
  space_id = null

  # 用户
  # {
  #   "timestamp": 1460549812,
  #   "items": [
  #     {
  #       "open_id": "0f09375d4e73599bcfa665d195fa7697",
  #       "gender": 1,
  #       "account": "test",
  #       "realname": "test",
  #       "title": ":",
  #       "p_dept_id": [
  #         1754170384,
  #         1
  #       ],
  #       "mobile": 0,
  #       "hidden": 0,
  #       "p_open_id": "",
  #       "role_id": 0
  #     }
  #   ]
  # }
  user_data = BQQ.userGet()
  console.log(JSON.stringify(user_data))
  owner_id = null
  admin_ids = []
  user_data.items.forEach (u) ->
    console.log("新建用户")
    user_id = null
    uq = db.users.find({"services.bqq.id": u.open_id})
    if uq.count() > 0
      console.log('用户已存在')
      user_id = uq.fetch()[0]._id
    else
      console.log('用户不存在')
      doc = {}
      doc.name = u.realname
      doc.locale = "zh-cn"
      doc.created = now
      doc.modified = now
      doc.services = {bqq:{id: u.open_id}}
      console.log(doc)
      user_id = db.users.direct.insert(doc)

    if u.role_id == 0
      owner_id = user_id
    else if u.role_id == 1
      admin_ids.push(user_id)
    
    u.user_id = user_id


  # 新建工作区
  if owner_id
    console.log("新建工作区")
    space_id = null
    s_id = "bqq-" + space_data.company_id
    sq = db.spaces.find({_id: s_id})
    if sq.count() > 0
      console.log('工作区已存在')
      space_id = s_id
    else
      console.log('工作区不存在')
      s_doc = {}
      s_doc._id = s_id
      s_doc.name = space_data.company_name
      s_doc.owner = owner_id
      s_doc.admins = admin_ids.concat([owner_id])
      s_doc.created = now
      s_doc.created_by = owner_id
      s_doc.modified = now
      s_doc.modified_by = owner_id
      s_doc.services = { bqq:{ expires_in: oauth.expires_in, refresh_token: oauth.refresh_token, company_id: oauth.company_id, company_token: oauth.company_token }}
      console.log(s_doc)
      space_id = db.spaces.direct.insert(s_doc)


  # 部门
  # {
  #   "timestamp": 1460551018,
  #   "items": [
  #     {
  #       "dept_id": 1,
  #       "p_dept_id": 0,
  #       "dept_name": "Test_lucy_标准"
  #     },
  #     {
  #       "dept_id": 1136750599,
  #       "p_dept_id": 1,
  #       "dept_name": "总经理办公室"
  #     },
  #     {
  #       "dept_id": 1754170384,
  #       "p_dept_id": 1136750599,
  #       "dept_name": "秘书组"
  #     }
  #   ]
  # }
  create_org = (depts, p_dept_id, space_id, company_id, owner_id) ->
    console.log("新建部门")
    orgs = depts.filter((d) -> 
              if d.p_dept_id == p_dept_id
                return true
            )
    if orgs.length > 0
      orgs.forEach (o) ->
        org_id = null
        o_id = "bqq-" + company_id + "-" + o.dept_id
        oq = db.organizations.find({_id: o_id})
        if oq.count() > 0
          org_id = o_id
        else
          org_doc = {}
          org_doc._id = o_id
          org_doc.space = space_id
          org_doc.name = o.dept_name
          if p_dept_id > 0
            org_doc.parent = "bqq-" + company_id + "-" + p_dept_id
          if p_dept_id == 0
            org_doc.is_company = true
          org_doc.created = now
          org_doc.created_by = owner_id
          org_doc.modified = now
          org_doc.modified_by = owner_id
          console.log(org_doc)
          org_id = db.organizations.direct.insert(org_doc)
        if org_id
          create_org(depts, o.dept_id, space_id, company_id, owner_id)

  org_data = BQQ.deptGet()
  console.log(JSON.stringify(org_data))
  create_org(org_data.items, 0, space_id, space_data.company_id, owner_id)


  # 新建space_user
  user_data.items.forEach (u) ->
    console.log("新建space_user")
    su_id = "bqq-" + u.open_id
    suq = db.space_users.find({_id: su_id})
    if suq.count() == 0
      console.log('space_user不存在')
      su_doc = {}
      su_doc._id = su_id
      su_doc.user = u.user_id
      su_doc.space = space_id
      su_doc.user_accepted = true
      su_doc.name = u.realname
      su_doc.created = now
      su_doc.created_by = owner_id

      p_dept_id = null
      if u.p_dept_id && u.p_dept_id.length >0
        p_dept_id = u.p_dept_id[0]
      if p_dept_id
        su_doc.organization = "bqq-" + space_data.company_id + "-" + p_dept_id
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

  # 更新space_user直属上级
  user_data.items.forEach (u) ->
    if u.p_open_id
      console.log('更新space_user直属上级')
      console.log(u.realname)
      manager = db.space_users.findOne("bqq-"+u.p_open_id, {fields: {user: 1}})
      db.space_users.direct.update("bqq-"+u.open_id, {$set:{manager: manager.user}})


  # 更新 org
  db.organizations.find({space: space_id}).forEach (org) ->
    console.log('更新部门')
    updateFields = {}
    updateFields.parents = org.calculateParents()
    updateFields.fullname = org.calculateFullname()

    if !_.isEmpty(updateFields)
      db.organizations.direct.update(org._id, {$set: updateFields})

    if org.parent
      parent = db.organizations.findOne(org.parent)
      db.organizations.direct.update(parent._id, {$set: {children: parent.calculateChildren()}})























BQQ.cleanSync = () ->
  db.users_changelogs.direct.remove({space: "bqq-c4609934c326caf9fd0053823bb99947"})

  db.space_users.direct.remove({space: "bqq-c4609934c326caf9fd0053823bb99947"})


  db.organizations.direct.remove({space: "bqq-c4609934c326caf9fd0053823bb99947"})


  db.users.direct.remove({"services.bqq.id": {$ne: null}})

  db.spaces.direct.remove({"services.bqq.company_id": {$ne: null}})










