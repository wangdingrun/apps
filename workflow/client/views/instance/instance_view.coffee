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
    'click .instance .form-control,.instance .suggestion-control,.instance .checkbox input,.instance .af-radio-group input,.instance .af-checkbox-group input': (event, template) ->
        console.log("click " + event.target.name);
        Session.set("instance_change", true);
    'change .ins-file-input': (event, template)->
            $(document.body).addClass("loading")
            $('.loading-text').text "正在上传..."

            files = event.target.files
            i = 0 
            while i < files.length
                file = files[i]
                if !file.name
                    continue

                fileName = file.name
                if ["image.jpg", "image.gif", "image.jpeg", "image.png"].includes(fileName.toLowerCase())
                    fileName = "image-" + moment(new Date()).format('YYYYMMDDHHmmss') + "." + fileName.split('.').pop()
                
                Session.set("filename", fileName)
                $('.loading-text').text "正在上传..." + fileName

                fd = new FormData
                fd.append('Content-Type', cfs.getContentType(fileName))
                fd.append("file", file)

                $.ajax
                  url: Steedos.settings.webservices.s3.url
                  type: 'POST'
                  async: true
                  data: fd
                  dataType: 'json'
                  processData: false
                  contentType: false
                  success: (responseText, status) ->
                    $(document.body).removeClass 'loading'
                    $('.loading-text').text ""
                    if responseText.errors
                        responseText.errors.forEach (e) ->
                            toastr.error e.errorMessage
                            return
                        return
                    fileObj = {}
                    fileObj._id = responseText.version_id
                    fileObj.name = Session.get('filename')
                    fileObj.type = cfs.getContentType(Session.get('filename'))
                    fileObj.size = responseText.size
                    InstanceManager.addAttach(fileObj, false)
                    return
                  error: (xhr, msg, ex) ->
                    $(document.body).removeClass 'loading'
                    $('.loading-text').text ""
                    toastr.error msg
                    return

                i++

            $(".ins-file-input").val('')

