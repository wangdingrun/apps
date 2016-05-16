if Meteor.isServer
    db.spaces.after.insert (userId, doc) ->
        console.log("insert space")

        space_id = doc._id
        user = db.users.findOne(userId)
        # 新建organization
        org = {}
        org.space = space_id
        org.name = doc.name
        org.fullname = doc.name
        org.parents = []
        org.parent = ""
        org.is_company = true
        org.users = [userId]
        org_id = db.organizations.direct.insert(org)
        if org_id
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
            procurement.users = []
            db.organizations.direct.insert(procurement)

            # 销售部
            sales = {}
            sales.space = space_id
            sales.name = sales_name
            sales.fullname = org.name + '/' + sales.name
            sales.parents = [org_id]
            sales.parent = org_id
            sales.is_company = false
            sales.users = []
            db.organizations.direct.insert(sales)
            
            # 财务部
            finance = {}
            finance.space = space_id
            finance.name = finance_name
            finance.fullname = org.name + '/' + finance.name
            finance.parents = [org_id]
            finance.parent = org_id
            finance.is_company = false
            finance.users = []
            db.organizations.direct.insert(finance)

            # 行政部
            administrative = {}
            administrative.space = space_id
            administrative.name = administrative_name
            administrative.fullname = org.name + '/' + administrative.name
            administrative.parents = [org_id]
            administrative.parent = org_id
            administrative.is_company = false
            administrative.users = []
            db.organizations.direct.insert(administrative)

            # 人事部
            human_resources = {}
            human_resources.space = space_id
            human_resources.name = human_resources_name
            human_resources.fullname = org.name + '/' + human_resources.name
            human_resources.parents = [org_id]
            human_resources.parent = org_id
            human_resources.is_company = false
            human_resources.users = []
            db.organizations.direct.insert(human_resources)

        # 创建spaceuser
        spaceUser = {}
        spaceUser.user = userId
        spaceUser.space = space_id
        spaceUser.organization = org_id
        spaceUser.name = user.name
        spaceUser.email = user.email
        spaceUser.mobile = user.mobile
        spaceUser.user_accepted = true

        # 根据locale和模板创建表单流程
        template_space_id = null
        if Meteor.user().locale == "zh-cn"
            template_space_id = "526621803349041651000a1a"
        else
            template_space_id = "526785fb3349041651000a75"
        db.forms.find({"space": template_space_id, "state": "enabled"}).forEach (template_form) ->
            # Form
            new_form = {}
            new_form._id = db.forms._makeNewID()
            new_form.name = template_form.name
            new_form.state = "enabled"
            new_form.is_deleted = false
            new_form.is_valid = template_form.is_valid
            new_form.space = space_id
            new_form.description = template_form.description
            new_form.help_text = template_form.help_text
            new_form.error_message = template_form.error_message

            current = {}
            current._id = Meteor.uuid()
            current.form = new_form._id
            current._rev = 1
            current.start_date = new Date()
            current.fields = template_form.current.fields
            new_form.current = current
            new_form.historys = []
            new_form_id = db.forms.direct.insert(new_form)

            db.flows.find({"space": template_space_id, "form": template_form._id, "state": "enabled"}).forEach (template_flow) ->
                # flow
                new_flow = {}
                new_flow._id = db.flows._makeNewID()
                new_flow.space = space_id
                new_flow.form = new_form_id
                new_flow.name = template_flow.name
                new_flow.name_formula = template_flow.name_formula
                new_flow.code_formula = template_flow.code_formula
                new_flow.flowtype = template_flow.flowtype
                new_flow.state = "enabled"
                new_flow.description = template_flow.description
                new_flow.help_text = template_flow.help_text
                new_flow.error_message = template_flow.error_message
                new_flow.app = template_flow.app
                new_flow.current_no = 0
                new_flow.is_deleted = false
                new_flow.is_valid = true
                new_flow.error_message = template_flow.error_message

                new_current = {}
                new_current._id = Meteor.uuid()
                new_current._rev = 1
                new_current.flow = new_flow._id
                new_current.form_version = new_form.current._id
                new_current.start_date = new Date()
                new_current.steps = template_flow.current.steps

                new_perms = {}
                new_perms._id = Meteor.uuid()
                new_perms.orgs_can_add = [org_id]

                new_flow.perms = new_perms
                new_flow.current = new_current
                new_flow.historys = []
                
                db.flows.direct.insert(new_flow)


