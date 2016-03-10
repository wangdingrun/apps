UUflow_api = {};

var workflowServer = "http://192.168.0.23";

// 新建instance（申请单）
UUflow_api.post_draft = function(flowId) {
  var uobj = {};
  uobj.methodOverride = "POST";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = workflowServer + "/uf/drafts?" + $.param(uobj);
  var data = 
  {
    "Instances": [
      {
        "flow": flowId,
        "applicant": localStorage.getItem("Meteor.userId"),
        "space": Session.get("spaceId")
      }
    ]
  };
  data = JSON.stringify(data);

  console.log(data);

  $.ajax({
    url: url,
    type: "POST",
    async: true,
    data: data,
    dataType: "json",
    processData: false,
    contentType: "text/plain",

    success: function(responseText, status) {
      Session.set("instanceId", responseText.ChangeSet.inserts.Instances[0].id);
      $('#createInsModal').modal('hide');
    },
    error: function(xhr, msg, ex) {
      // alert("e");
    }
  })
}

// 拟稿状态下暂存instance（申请单）
UUflow_api.put_draft = function(instance) {
  var uobj = {};
  uobj.methodOverride = "PUT";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = workflowServer + "/uf/drafts?" + $.param(uobj);
  var data = {"Instances":[instance]};
  data = JSON.stringify(data);
  console.log(data);
  $.ajax({
    url: url,
    type: "POST",
    async: true,
    data: data,
    dataType: "json",
    processData: false,
    contentType: "text/plain",

    success: function(responseText, status) {
      // alert("s");
    },
    error: function(xhr, msg, ex) {
      // alert("e");
    }
  })
}

// 拟稿状态下删除instance（申请单）
UUflow_api.delete_draft = function(instanceId) {
  var uobj = {};
  uobj.methodOverride = "DELETE";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = workflowServer + "/uf/drafts?" + $.param(uobj);
  var data = 
  { "Instances": 
    [
      {
      "id": instanceId
      }
    ]
  };
  data = JSON.stringify(data);
  console.log(data);
  $.ajax({
    url: url,
    type: "POST",
    async: true,
    data: data,
    dataType: "json",
    processData: false,
    contentType: "text/plain",

    success: function(responseText, status) {
      box = Session.get("box");
      if (box) {
        if (box == "monitor") {
          FlowRouter.go("/workflow/monitor/" + Session.get("spaceId") + "/" + Session.get("flowId"));
        } else if (box == "draft") {
          FlowRouter.go("/workflow/draft/" + Session.get("spaceId"));
        }
      }
      
    },
    error: function(xhr, msg, ex) {
      // alert("e");
    }
  })
}

// instance（申请单）的第一次提交
UUflow_api.post_submit = function(instance) {
  var uobj = {};
  uobj.methodOverride = "POST";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = workflowServer + "/uf/submit?" + $.param(uobj);
  var data = {"Instances":[instance]};
  data = JSON.stringify(data);
  console.log(data);
  $.ajax({
    url: url,
    type: "POST",
    async: true,
    data: data,
    dataType: "json",
    processData: false,
    contentType: "text/plain",

    success: function(responseText, status) {
      FlowRouter.go("/workflow/draft/" + Session.get("spaceId"));
    },
    error: function(xhr, msg, ex) {
      // alert("e");
    }
  })
}

// 审核状态下暂存instance（申请单）
UUflow_api.put_approvals = function(approve) {
  var uobj = {};
  uobj.methodOverride = "PUT";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = workflowServer + "/uf/approvals?" + $.param(uobj);
  var data = {"Approvals":[approve]};
  data = JSON.stringify(data);
  console.log(data);
  $.ajax({
    url: url,
    type: "POST",
    async: true,
    data: data,
    dataType: "json",
    processData: false,
    contentType: "text/plain",

    success: function(responseText, status) {
      // alert("s");
    },
    error: function(xhr, msg, ex) {
      // alert("e");
    }
  })
}

// 待审核提交
UUflow_api.post_engine = function(approve) {
  var uobj = {};
  uobj.methodOverride = "POST";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = workflowServer + "/uf/engine?" + $.param(uobj);
  var data = {"Approvals":[approve]};
  data = JSON.stringify(data);
  console.log(data);
  $.ajax({
    url: url,
    type: "POST",
    async: true,
    data: data,
    dataType: "json",
    processData: false,
    contentType: "text/plain",

    success: function(responseText, status) {
      FlowRouter.go("/workflow/inbox/" + Session.get("spaceId"));
    },
    error: function(xhr, msg, ex) {
      // alert("e");
    }
  })
}

// 取消申请
UUflow_api.post_terminate = function(instance) {
  var uobj = {};
  uobj.methodOverride = "POST";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = workflowServer + "/uf/terminate?" + $.param(uobj);
  var data = {"Instances":[instance]};
  data = JSON.stringify(data);
  console.log(data);
  $.ajax({
    url: url,
    type: "POST",
    async: true,
    data: data,
    dataType: "json",
    processData: false,
    contentType: "text/plain",

    success: function(responseText, status) {
      $('#force_end_modal').modal('hide');
    },
    error: function(xhr, msg, ex) {
      // alert("e");
    }
  })
}

// 转签核
UUflow_api.put_reassign = function(instance) {
  var uobj = {};
  uobj.methodOverride = "PUT";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = workflowServer + "/uf/reassign?" + $.param(uobj);
  var data = {"Instances":[instance]};
  data = JSON.stringify(data);
  console.log(data);
  $.ajax({
    url: url,
    type: "POST",
    async: true,
    data: data,
    dataType: "json",
    processData: false,
    contentType: "text/plain",

    success: function(responseText, status) {
      $('#reassign_modal').modal('hide');
    },
    error: function(xhr, msg, ex) {
      // alert("e");
    }
  })
}

// 导出报表
UUflow_api.get_export = function (spaceId, flowId, type) {
  var uobj = {};
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  uobj.space_id = spaceId;
  uobj.flow_id = flowId;
  uobj.timezoneoffset = new Date().getTimezoneOffset();
  uobj.type = type;
  var url = workflowServer + "/uf/export/excel?" + $.param(uobj);
  window.open(url, "_blank");
}

// 打印
UUflow_api.print = function(instanceId){
  var uobj = {};
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  uobj.id = instanceId;
  window.open(workflowServer + "/uf/print?" + $.param(uobj));
}
