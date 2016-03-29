Template.instance_list.helpers
        
    instances: ->
        return db.instances.find({}, {sort: {modified: -1}});

    boxName: ->
        return Session.get("box");

    spaceId: ->
        return Session.get("spaceId");

    selector: ->
        query = {space: Session.get("spaceId")}
        box = Session.get("box") 
        if box == "inbox"
            query.inbox_users = Meteor.userId();
        else if box == "outbox"
            query.outbox_users = Meteor.userId();
        else if box == "draft"
            query.submitter = Meteor.userId();
            query.state = "draft"
        else if box == "pending"
            query.submitter = Meteor.userId();
            query.state = "pending"
        else if box == "completed"
            query.submitter = Meteor.userId();
            query.state = "completed"
        else if box == "monitor"
            query.flow = Session.get("flowId");
            query.state = {$in: ["pending","completed"]};
            uid = Meteor.userId();
            space = db.spaces.findOne(Session.get("spaceId"));
            if !space
                return;
            if !space.admins.contains(uid)
                query.$or = [{submitter:uid}, {applicant:uid}, {inbox_users:uid}, {outbox_users:uid}]
        else
            query.state = "none"

        return query

    enabled_export: ->
        spaceId = Session.get("spaceId");
        if !spaceId
            return;
        space = db.spaces.findOne(spaceId);
        if !space
            return;
        if Session.get("box")=="monitor" && space.admins.contains(Meteor.userId())
            return "";
        else
            return "display: none;";


Template.instance_list.events

    'hidden.bs.modal #createInsModal': (event)->
        insId = Session.get("instanceId");
        if insId
            FlowRouter.go("/workflow/draft/" + Session.get("spaceId") + "/" + insId);

    'click tbody > tr': (event) ->
        dataTable = $(event.target).closest('table').DataTable();
        rowData = dataTable.row(event.currentTarget).data();
        if (!rowData) 
            return; 
        box = Session.get("box");
        spaceId = Session.get("spaceId");
        if box && spaceId
            if box == "monitor"
                flowId = Session.get("flowId");
                if flowId
                    FlowRouter.go("/workflow/monitor/" + spaceId + "/" + flowId + "/" + rowData._id)
            else
                FlowRouter.go("/workflow/" + box + "/" + spaceId + "/" + rowData._id);
                if box == "completed"
                    InstanceManager.archiveIns(rowData._id);

    
    'click .dropdown-menu li a': (event) -> 
        InstanceManager.exportIns(event.target.type);


    'shown.bs.modal #createInsModal': (event) ->
        data = [];
        categories = WorkflowManager.getSpaceCategories();
        #生成树
        categories.forEach (cat) ->
            o =  {};
            o.text = cat.name;
            o.nodes = [];
            forms = db.forms.find({category:cat._id});
            forms.forEach (f) ->
                db.flows.find({form:f._id}).forEach (fl) ->
                    o.nodes.push({text:fl.name, flow_id: fl._id})
            data.push(o);

        forms = db.forms.find({category:{$in:[null,""]}});
        forms.forEach (f) ->
            db.flows.find({form:f._id}).forEach (fl) ->
                data.push({text:fl.name, flow_id: fl._id});

        $('#tree').treeview({data: data});
        #新建流程
        $('#tree').on('nodeSelected', (event, data)->
                InstanceManager.newIns(data.flow_id)
            )



