if Meteor.isServer
    db.spaces.after.insert (userId, doc) ->
        console.log("insert space")
        now = new Date
        space_id = doc._id
        user = db.users.findOne(userId)
        # 新建organization
        org = {}
        org.space = space_id
        org.name = doc.name
        org.fullname = doc.name
        org.is_company = true
        org_id = db.organizations.insert(org)
        if org_id
            # 创建spaceuser
            spaceUser = {}
            spaceUser.user = userId
            spaceUser.space = space_id
            spaceUser.organization = org_id
            spaceUser.name = user.name
            spaceUser.email = user.email
            spaceUser.mobile = user.mobile
            spaceUser.user_accepted = true
            db.space_users.insert(spaceUser)

            # 新建5个部门
            if Meteor.user().locale == "zh-cn"
                procurement_name = "采购部"
                sales_name = "销售部"
                finance_name = "财务部"
                administrative_name = "行政部"
                human_resources_name = "人事部"
            else
                procurement_name = "Procurement Department"
                sales_name = "Sales Department"
                finance_name = "Finance Department"
                administrative_name = "Administrative Department"
                human_resources_name = "Human Resources Department"

            # 采购部
            procurement = {}
            procurement.space = space_id
            procurement.name = procurement_name
            procurement.fullname = org.name + '/' + procurement.name
            procurement.parents = [org_id]
            procurement.parent = org_id
            procurement.is_company = false
            db.organizations.insert(procurement)

            # 销售部
            sales = {}
            sales.space = space_id
            sales.name = sales_name
            sales.fullname = org.name + '/' + sales.name
            sales.parents = [org_id]
            sales.parent = org_id
            sales.is_company = false
            db.organizations.insert(sales)
            
            # 财务部
            finance = {}
            finance.space = space_id
            finance.name = finance_name
            finance.fullname = org.name + '/' + finance.name
            finance.parent = org_id
            finance.is_company = false
            db.organizations.insert(finance)

            # 行政部
            administrative = {}
            administrative.space = space_id
            administrative.name = administrative_name
            administrative.fullname = org.name + '/' + administrative.name
            administrative.parent = org_id
            administrative.is_company = false
            db.organizations.insert(administrative)

            # 人事部
            human_resources = {}
            human_resources.space = space_id
            human_resources.name = human_resources_name
            human_resources.fullname = org.name + '/' + human_resources.name
            human_resources.parent = org_id
            human_resources.is_company = false
            db.organizations.insert(human_resources)

        

        # 根据locale和模板创建表单流程
        template_space_id = null
        if Meteor.user().locale == "zh-cn"
            template_space_id = "526621803349041651000a1a"
        else
            template_space_id = "526785fb3349041651000a75"
        BQQ.createTemplateFormAndFlow(template_space_id, space_id, org_id, userId)


