
Template.instance_attachments.helpers({

    isUploading: function () {
        return Session.get("file_id");
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