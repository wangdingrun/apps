Template.space_select.helpers
        spaces: ()->
                return db.spaces.find()
                
        urlPrefix: ->
                return __meteor_runtime_config__.ROOT_URL_PATH_PREFIX

Template.space_select.onRendered ->
  if (Session.get("spaceId"))
    FlowRouter.go("/space/" + Session.get("spaceId") + "/inbox/")

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
