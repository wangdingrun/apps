db.spaces = new Meteor.Collection('spaces')


db.spaces._simpleSchema = new SimpleSchema
    name: 
        type: String,
        # unique: true,
        max: 200
    owner: 
        type: String,
        optional: true,
        autoform:
            type: "selectuser"
            defaultValue: ->
                return Meteor.userId

    admins: 
        type: [String],
        optional: true,
        autoform:
            type: "selectuser"
            multiple: true
        # autoform: 
        #     type: "select",
        #     afFieldInput: 
        #         multiple: true
        #     options: ->
        #         options = []
        #         selector = {}
        #         if Session.get("spaceId")
        #             selector = {space: Session.get("spaceId")}

        #         objs = db.space_users.find(selector, {name:1, sort: {name:1}})
        #         objs.forEach (obj) ->
        #             options.push
        #                 label: obj.name,
        #                 value: obj.user
        #         return options

    balance: 
        type: Number,
        optional: true,
        autoform:
            omit: true
    is_paid: 
        type: Boolean,
        label: t("Spaces_isPaid"),
        optional: true,
        autoform:
            omit: true
            readonly: true
        # 余额>0为已付费用户
        autoValue: ->
            balance = this.field("balance")
            if (balance.isSet)
                return balance.value>0
            else
                this.unset()
    created:
        type: Date,
        optional: true
    created_by:
        type: String,
        optional: true
    modified:
        type: Date,
        optional: true
    modified_by:
        type: String,
        optional: true
    services:
        type: Object
        optional: true,
        blackbox: true
        autoform:
            omit: true
    # "services.bqq.expires_in":
    #     type: Number,
    #     optional: true
    # "services.bqq.company_id":
    #     type: String,
    #     optional: true
    # "services.bqq.company_token":
    #     type: String,
    #     optional: true
    # "services.bqq.refresh_token":
    #     type: String,
    #     optional: true
    # "services.bqq.user_list_timestamp":
    #     type: Number,
    #     optional: true
    # "services.bqq.dept_list_timestamp":
    #     type: Number,
    #     optional: true
    # "services.bqq.modified":
    #     type: Number,
    #     optional: true


if Meteor.isClient
    db.spaces._simpleSchema.i18n("db_spaces")

db.spaces.attachSchema(db.spaces._simpleSchema)


db.spaces.helpers

    owner_name: ->
        owner = db.users.findOne({_id: this.owner});
        return owner && owner.name;
    
    admins_name: ->
        if (!this.admins)
            return ""
        admins = db.users.find({_id: {$in: this.admins}}, {fields: {name:1}});
        adminNames = []
        admins.forEach (admin) ->
            adminNames.push(admin.name)
        return adminNames.toString();

# if Meteor.isClient

#     db.spaces.find().observeChanges
#         added: (_id, fields) ->
#             if !Session.get("spaceId")
#                 Meteor.call "setSpaceId", _id, ->
#                     Session.set("spaceId", _id)
                
#         removed: (_id)->
#             if Session.get("spaceId") == _id
#                 spaceId = null
#                 nextSpace = db.spaces.findOne()
#                 if nextSpace
#                     spaceId  = nextSpace._id
#                 Meteor.call "setSpaceId", spaceId, ->
#                     Session.set("spaceId", spaceId)

if Meteor.isServer
    
    db.spaces.before.insert (userId, doc) ->
        if !userId and doc.owner
            userId = doc.owner

        doc.created_by = userId
        doc.created = new Date()
        doc.modified_by = userId
        doc.modified = new Date()
        
        if !userId
            throw new Meteor.Error(400, t("spaces_error.login_required"));

        doc.owner = userId
        doc.admins = [userId]


    db.spaces.after.insert (userId, doc) ->
        db.spaces.createTemplateOrganizations(doc._id)
        _.each doc.admins, (admin) ->
            db.spaces.space_add_user(doc._id, admin, true)
            

    db.spaces.before.update (userId, doc, fieldNames, modifier, options) ->
        modifier.$set = modifier.$set || {};

        # only space owner can modify space
        if doc.owner != userId
            throw new Meteor.Error(400, t("spaces_error.space_owner_only"));

        modifier.$set.modified_by = userId;
        modifier.$set.modified = new Date();

        # Add owner as admins
        if modifier.$set.owner
            if (!modifier.$set.admins)
                modifier.$set.admins = doc.admins
                if modifier.$unset
                    delete modifier.$set.admins
            else if (modifier.$set.admins.indexOf(modifier.$set.owner) <0)
                modifier.$set.admins.push(modifier.$set.owner)
        
        # 管理员不能为空
        if (!modifier.$set.admins)
            throw new Meteor.Error(400, t("spaces_error.space_admins_required"));


    db.spaces.after.update (userId, doc, fieldNames, modifier, options) ->
        self = this
        modifier.$set = modifier.$set || {};

    db.spaces.before.remove (userId, doc) ->
        throw new Meteor.Error(400, "暂不支持删除工作区操作");


    Meteor.methods
        setSpaceId: (spaceId) ->
            this.connection["spaceId"] = spaceId
            return this.connection["spaceId"]
        getSpaceId: ()->
            return this.connection["spaceId"]


    db.spaces.space_add_user = (spaceId, userId, user_accepted) ->
        spaceUserObj = db.space_users.direct.findOne({user: userId, space: spaceId})
        userObj = db.users.direct.findOne(userId);
        if (!userObj)
            return;
        if (spaceUserObj)
            db.space_users.direct.update spaceUserObj._id, 
                $set:
                    name: userObj.name,
                    email: userObj.email,
                    space: spaceId,
                    user: userObj._id,
                    user_accepted: user_accepted
        else 
            root_org = db.organizations.findOne({space: spaceId, is_company:true})
            db.space_users.direct.insert
                name: userObj.name,
                email: userObj.email,
                space: spaceId,
                organization: root_org._id,
                user: userObj._id,
                user_accepted: user_accepted
        
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

        # 初始化 space owner 的 orgnization
        # db.space_users.direct.update({space: space_id, user: space.owner}, {$set: {organization: org_id}})

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

        