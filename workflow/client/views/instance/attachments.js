
Template.instance_attachments.helpers({

    isUploading: function () {
        return Session.get("file_id");
    },

    can_delete: function (currentApproveId) {
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return false;
        var isCurrentApprove = false;
        var isDraftOrInbox = false;
        var isFlowEnable = false;
        var box = Session.get("box");

        var currentApprove = InstanceManager.getCurrentApprove();
        if (currentApprove.id = currentApproveId)
            isCurrentApprove = true;

        if (box == "draft" || box == "inbox")
            isDraftOrInbox = true;

        var flow = db.flows.findOne(ins.flow, {fields: {state: 1}});
        if (flow && flow.state == "enabled")
            isFlowEnable = true;

        return isCurrentApprove && isDraftOrInbox && isFlowEnable;
    }
 
})


Template._file_DeleteButton.events({

    'click button': function(event, template) {
        var fileObj = template.data.fileObj;
        if (!fileObj) {
           return false;
        }
        Session.set("file_id", fileObj._id);
        fileObj.remove(function(){InstanceManager.removeAttach();});
        return false;
    }

})