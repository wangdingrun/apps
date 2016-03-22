
Template.instance_attachments.helpers({

    isUploading: function () {
        return Session.get("file_id");
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
        var file_id = template.data.file_id;
        if (!file_id) {
           return false;
        }
        Session.set("file_id", file_id);
        cfs.instances.remove({_id: file_id}, function(){InstanceManager.removeAttach();});
        return false;
    }

})


Template.ins_attach_version_modal.helpers({

    attach_data: function () {
        return Session.get("attach_data");
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
    'click button': function (event, template) {
        Session.set("attach_data", template.data);
        $('#ins_attach_version_modal').modal();
    }
})






