
Template.instance_attachments.helpers({
    
    enabled_add_attachment: function() {
        if (Session.get("box")=="draft" || Session.get("box")=="inbox")
            return "";
        else
            return "display: none;";
        
    } 
})


Template.instance_attachment.helpers({

    can_delete: function (currentApproveId, historys) {
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return false;
        var isCurrentApprove = false;
        var isDraftOrInbox = false;
        var isFlowEnable = false;
        var isHistoryLenthZero = false;
        var box = Session.get("box");

        var currentApprove = InstanceManager.getCurrentApprove();
        if (currentApprove.id == currentApproveId)
            isCurrentApprove = true;

        if (box == "draft" || box == "inbox")
            isDraftOrInbox = true;

        var flow = db.flows.findOne(ins.flow, {fields: {state: 1}});
        if (flow && flow.state == "enabled")
            isFlowEnable = true;

        if (!historys || historys.length == 0) {
            isHistoryLenthZero = true;
        }

        return isCurrentApprove && isDraftOrInbox && isFlowEnable && isHistoryLenthZero;
    },

    getUrl: function (attachVersion) {
        return Meteor.absoluteUrl() + "api/files/instances/" + attachVersion._rev + "/" + attachVersion.filename + "?download=true"; 
    }
 
})

Template.instance_attachment.events({
    "click [name='ins_attach_version']": function (event, template) {
        Session.set("attach_id", event.target.id);
    }
})

Template._file_DeleteButton.events({

    'click div': function(event, template) {
        var file_id = template.data.file_id;
        if (!file_id) {
           return false;
        }
        Session.set("file_id", file_id);
        cfs.instances.remove({_id:file_id}, function(error){InstanceManager.removeAttach();})
        return true;
    }

})


Template.ins_attach_version_modal.helpers({

    attach: function () {
        WorkflowManager.instanceModified.get();

        var ins_id, ins_attach_id;
        ins_id = Session.get("instanceId");
        ins_attach_id = Session.get("attach_id");
        if (!ins_id || !ins_attach_id)
            return;
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return;
        if (!ins.attachments)
            return;
        var attach = ins.attachments.filterProperty("_id", ins_attach_id);
        if (attach) {
            return attach[0];
        } else {
            return;
        }
    },

    isUploading: function () {
        return Session.get("progress_version_file_id");
    },

    attach_version_info: function (attachVersion) {
        var owner_name = attachVersion.created_by_name;
        var uploadedAt = attachVersion.created;
        return owner_name + " , " + $.format.date(uploadedAt, "yyyy-MM-dd HH:mm");
    },

    enabled_add_attachment: function() {
        if (Session.get("box")=="draft" || Session.get("box")=="inbox")
            return "";
        else
            return "display: none;";
        
    },
    
    current_can_delete: function (currentApproveId, historys) {
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return false;
        var isCurrentApprove = false;
        var isDraftOrInbox = false;
        var isFlowEnable = false;
        var isHistoryLenthZero = false;
        var box = Session.get("box");

        var currentApprove = InstanceManager.getCurrentApprove();
        if (currentApprove.id == currentApproveId)
            isCurrentApprove = true;

        if (box == "draft" || box == "inbox")
            isDraftOrInbox = true;

        var flow = db.flows.findOne(ins.flow, {fields: {state: 1}});
        if (flow && flow.state == "enabled")
            isFlowEnable = true;

        if (!historys || historys.length == 0) {
            isHistoryLenthZero = true;
        }

        return isCurrentApprove && isDraftOrInbox && isFlowEnable && !isHistoryLenthZero;
    },

    getUrl: function (attachVersion) {
        return window.location.origin + "/api/files/instances/" + attachVersion._rev + "/" + attachVersion.filename + "?download=true"; 
    }
})


Template.ins_attach_version_modal.events({

    'change .ins-file-version-input': function (event, template) {
        
        FS.Utility.eachFile(event, function(file){
            newFile = new FS.File(file);
            currentApprove = InstanceManager.getCurrentApprove();
            newFile.metadata = {owner:Meteor.userId(), space:Session.get("spaceId"), instance:Session.get("instanceId"), approve: currentApprove.id, attach_id: Session.get("attach_id")};
            cfs.instances.insert(newFile, function(err, fileObj){
                if (err) {
                    toastr.error(err);
                } else {
                    Session.set("progress_version_file_id", fileObj._id);
                    fileObj.on("uploaded", function(){
                        InstanceManager.addAttach(fileObj, true);
                        fileObj.removeListener("uploaded");
                    })
                }
            })
        })
    }
})

Template._file_version_DeleteButton.events({

    'click div': function(event, template) {
        var file_id = template.data.file_id;
        if (!file_id) {
           return false;
        }

        Session.set("file_id", file_id);
        cfs.instances.remove({_id:file_id}, function(error){InstanceManager.removeAttach();})
        return true;
    }

})






