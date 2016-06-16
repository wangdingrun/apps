Template.instance_view.helpers
    instance: ->
        Session.get("change_date")
        if (Session.get("instanceId"))
            steedos_instance = WorkflowManager.getInstance();
            return steedos_instance;

    space_users: ->
        return db.space_users.find();

    unequals: (a,b) ->
        return !(a == b)

Template.instance_view.events
    'change .ins-file-input': (event, template)->
            $(document.body).addClass("loading");
            $('.loading-text').text "正在上传..."
            FS.Utility.eachFile event, (file) ->
                console.log "file_name"
                console.log file.name
                if !file.name
                    return

                fileName = file.name

                if ["image.jpg", "image.gif", "image.jpeg", "image.png"].includes(fileName.toLowerCase())
                    fileName = "image-" + moment(new Date()).format('YYYYMMDDHHmmss') + "." + fileName.split('.').pop();

                Session.set("filename", fileName)
                $('.loading-text').text "正在上传..." + fileName
  
                newFile = new FS.File(file);
                newFile.name(fileName)
                newFile.type(cfs.getContentType(fileName))
                currentApprove = InstanceManager.getCurrentApprove();
                newFile.metadata = {owner:Meteor.userId(), space:Session.get("spaceId"), instance:Session.get("instanceId"), approve: currentApprove.id};
                cfs.instances.insert newFile, (err,fileObj) -> 
                    if err
                        toastr.error(err);
                    else
                        #$('.loading-text').text fileObj.uploadProgress() + "%"
                        fileObj.on "uploaded", ()->
                            $(document.body).removeClass("loading");
                            $('.loading-text').text ""
                            InstanceManager.addAttach(fileObj, false);
                            fileObj.removeListener("uploaded");
