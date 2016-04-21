db.spaces = new Meteor.Collection('spaces')


db.spaces.attachSchema new SimpleSchema
    name: 
        type: String,
        # unique: true,
        max: 200
    owner: 
        type: String,
        optional: true,
        autoform:
            type: "select2",
            options: ->
                options = []
                selector = {}
                if Session.get("spaceId")
                    selector = {space: Session.get("spaceId")}

                objs = db.space_users.find(selector, {name:1, sort: {name:1}})
                objs.forEach (obj) ->
                    options.push
                        label: obj.name,
                        value: obj.user
                return options

            defaultValue: ->
                return Meteor.userId

    admins: 
        type: [String],
        optional: true,
        autoform: 
            type: "select2",
            afFieldInput: 
                multiple: true
            options: ->
                options = []
                selector = {}
                if Session.get("spaceId")
                    selector = {space: Session.get("spaceId")}

                objs = db.space_users.find(selector, {name:1, sort: {name:1}})
                objs.forEach (obj) ->
                    options.push
                        label: obj.name,
                        value: obj.user
                return options

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


if Meteor.isClient
    db.spaces.simpleSchema().i18n("db_spaces")


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

    join_space: (userId, user_accepted) ->
        spaceUserObj = db.space_users.direct.findOne({user: userId, space: this._id})
        userObj = db.users.direct.findOne(userId);
        if (!userObj)
            return;
        if (spaceUserObj)
            db.space_users.direct.update spaceUserObj._id, 
                $set:
                    name: userObj.name,
                    email: userObj.email,
                    space: this._id,
                    user: userObj._id,
                    user_accepted: user_accepted
        else 
            db.space_users.direct.insert
                name: userObj.name,
                email: userObj.email,
                space: this._id,
                user: userObj._id,
                user_accepted: user_accepted
        

if Meteor.isClient

    db.spaces.find().observeChanges
        added: (_id, fields) ->
            if !Session.get("spaceId")
                Meteor.call "setSpaceId", _id, ->
                    Session.set("spaceId", _id)
                
        removed: (_id)->
            if Session.get("spaceId") == _id
                spaceId = null
                nextSpace = db.spaces.findOne()
                if nextSpace
                    spaceId  = nextSpace._id
                Meteor.call "setSpaceId", spaceId, ->
                    Session.set("spaceId", spaceId)

if Meteor.isServer
    
    db.spaces.before.insert (userId, doc) ->
        doc.created_by = userId
        doc.created = new Date()
        doc.modified_by = userId
        doc.modified = new Date()
        
        if !userId
            throw new Meteor.Error(400, t("spaces_error.login_required"));

        doc.owner = userId
        doc.admins = [userId]


    db.spaces.after.insert (userId, doc) ->
        console.log("db.spaces.after.insert")
        if (doc.admins)
            space = db.spaces.findOne(doc._id)
            _.each doc.admins, (admin) ->
                space.join_space(admin, true)
            

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

        if (modifier.$set.admins)
            _.each modifier.$set.admins, (admin) ->
                self.transform().join_space(admin, true)

    db.spaces.before.remove (userId, doc) ->
        # only space owner can remove space
        if doc.owner != userId
            throw new Meteor.Error(400, t("spaces_error.space_owner_only"));

        db.space_users.direct.remove({space: doc._id});
        db.organizations.direct.remove({space: doc._id});
        

    Meteor.methods
        setSpaceId: (spaceId) ->
            this.connection["spaceId"] = spaceId
            return this.connection["spaceId"]
        getSpaceId: ()->
            return this.connection["spaceId"]

    
