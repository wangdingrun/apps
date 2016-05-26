Template.space_select.helpers
        spaces: ()->
                return db.spaces.find()
                
        urlPrefix: ->
                return __meteor_runtime_config__.ROOT_URL_PATH_PREFIX

Template.space_select.onRendered ->

  Tracker.autorun (c)->
    if Steedos.subsReady()
        # 如果只有一个工作区，自动跳转
        if db.spaces.find().count() == 1   
          FlowRouter.go("/space/" + db.spaces.findOne()._id + "/")
          c.stop();
          return true
        # 自动跳转到之前选中的工作区。
        if !Session.get("spaceId")
          savedSpaceId = localStorage.getItem("spaceId")
          if savedSpaceId
            if db.spaces.find({_id: savedSpaceId}).count() == 1  
              Session.set("spaceId", savedSpaceId) 
              FlowRouter.go "/space/" + savedSpaceId + "/";
              c.stop();
              return true

Template.space_select.events
  "click #space_add": (event, template) ->
    swal({
      title: "请输入工作区名称", 
      text: "", 
      type: "input",
      showCancelButton: true,
      closeOnCancel: true,
      closeOnConfirm: false,
      showLoaderOnConfirm: true
    }, (name) ->
      if !name
        return false

      Meteor.call 'adminInsertDoc', {name:name}, "spaces", (e,r)->
        if e
          swal("Error", e, "error")
          return false

        if r && r._id
          Session.set("spaceId", r._id)
          swal({
              title: "新建成功"
            }, () -> 
              console.log(Session.get('spaceId'))
              console.log("success")
              FlowRouter.go "/space/" + Session.get("spaceId")
          )
    )
