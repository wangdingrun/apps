
var attachmentServerURL = WorkflowManager.getUrlForServiceName("s3");

var applicationName = "workflow";

var spaceId = "52ba669333490464b4000065";

var instanceId = "5624afe2527eca4a33002e1d";

Template.instance_attachments.helpers({
    getAttachmentURL : function(attachment){

        var attachmentURL = attachmentServerURL 
                            + '/s3?key=' + "spaces/" + spaceId + '/' 
                            + applicationName + '/' + instanceId + '/' + encodeURI(attachment.filename,'UTF-8')
                            + '&version_id=' + attachment.current._rev;

        return attachmentURL;
    },

    attachments: function () {
    	var ins = WorkflowManager.getInstance();
    	if (ins) {
    		var attach_revs = ins.attachments.getEach("current").getEach("_rev");
    		return cfs.instances.find({_id: {$in: attach_revs}});
    	}
    }

})