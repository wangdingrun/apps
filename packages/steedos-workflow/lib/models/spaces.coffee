if Meteor.isServer
	db.spaces.after.insert (userId, doc) ->
		console.log("insert space")
		now = new Date
		space_id = doc._id
		user = db.users.findOne(doc.owner)

		# 改为订阅时初始化
		# db.spaces.createTemplateOrganizations(space_id)
		# db.spaces.createTemplateFormAndFlow(space_id)


	db.spaces.createTemplateOrganizations = (space_id)->
		space = db.spaces.findOne(space_id)
		if !space
			return false;
		user = db.users.findOne(space.owner)
		if !user
			reurn false

		if db.organizations.find({space: space_id}).count()>0
			return;

		# 新建organization
		org = {}
		org.space = space_id
		org.name = space.name
		org.fullname = space.name
		org.is_company = true
		org_id = db.organizations.insert(org)
		if !org_id
			return false

		# 创建 spaces 时会自动创建 space_user
		# # 创建spaceuser
		# spaceUser = {}
		# spaceUser.user = user._id
		# spaceUser.space = space_id
		# spaceUser.organization = org_id
		# spaceUser.name = user.name
		# spaceUser.email = user.email
		# spaceUser.mobile = user.mobile
		# spaceUser.user_accepted = true
		# db.space_users.insert(spaceUser)

		# 新建5个部门
		if user.locale == "zh-cn"
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

		return true

		
	db.spaces.createTemplateFormAndFlow = (space_id) ->
		console.log('新建表单流程模板')

		if db.forms.find({space: space_id}).count()>0
			return false;

		space = db.spaces.findOne(space_id)
		if !space
			return false;
		owner_id = space.owner

		user = db.users.findOne(space.owner)
		if !user
			reurn false

		root_org = db.organizations.findOne({space: space_id, is_company: true})
		if !root_org
			return false;

		if db.forms.find({space: space_id}).count()>0
			return;

		# 根据locale和模板创建表单流程
		template_space_id = null
		if user.locale == "zh-cn"
			template_space_id = "526621803349041651000a1a"
		else
			template_space_id = "526785fb3349041651000a75"

		now = new Date
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
			new_form.created_by = owner_id
			new_form.created = now

			current = {}
			current._id = Meteor.uuid()
			current.form = new_form._id
			current._rev = 1
			current.start_date = now
			current.fields = template_form.current.fields
			current.created_by = owner_id
			current.created = now
			current.modified_by = owner_id
			current.modified = now
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
				new_flow.created_by = owner_id
				new_flow.created = now

				new_current = {}
				new_current._id = Meteor.uuid()
				new_current._rev = 1
				new_current.flow = new_flow._id
				new_current.form_version = new_form.current._id
				new_current.start_date = now
				new_current.steps = template_flow.current.steps
				new_current.created_by = owner_id
				new_current.created = now
				new_current.modified_by = owner_id
				new_current.modified = now

				new_perms = {}
				new_perms._id = Meteor.uuid()
				new_perms.orgs_can_add = [root_org._id]

				new_flow.perms = new_perms
				new_flow.current = new_current
				new_flow.historys = []

				db.flows.direct.insert(new_flow)


