
Template.instance_attachments.helpers({

    isUploading: function () {
        return Session.get("progress_file_id");
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
    }
 
})

// Template.instance_attachment.events({

//     'click button': function(event, template) {
//         debugger;
//     }

// })


Template._file_DeleteButton.events({

    'click button': function(event, template) {
        var fileObj = template.data.fileObj;
        if (!fileObj) {
           return false;
        }
        Session.set("file_id", fileObj._id);
        fileObj.remove(function(){InstanceManager.removeAttach();});
        return true;
    }

})


Template.ins_attach_version_btn.helpers({

    isUploading: function () {
        return Session.get("progress_version_file_id");
    },

    attach_version_info: function (fileObj) {
        var owner_id = fileObj.metadata.owner;
        var uploadedAt = fileObj.uploadedAt;
        var owner = db.users.findOne(owner_id);
        if (!owner)
            return "";
        return owner.name + " , " + $.format.date(uploadedAt, "yyyy-MM-dd HH:mm");
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
    }
})


Template.ins_attach_version_btn.events({

    'change .ins-file-version-input': function (event, template) {
        console.log("ins_attach_version_btn");
        Session.set("attach_id", template.data._id);
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

    'click button': function(event, template) {
        var fileObj = template.data.fileObj;
        var modal_id = template.data.modal_id;
        if (!fileObj || !modal_id) {
           return false;
        }

        $('#' + modal_id).on('hidden.bs.modal', function(e){
            Session.set("file_id", fileObj._id);
            fileObj.remove(function(){InstanceManager.removeAttach();});
        })

        $('#' + modal_id).modal('hide');
        return true;
    }

})






