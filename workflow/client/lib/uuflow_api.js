UUflow_api = {};

// 新建instance（申请单）
UUflow_api.post_draft = function() {
  var uobj = {};
  uobj.methodOverride = "POST";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = "https://uuflowws.steedos.com/uf/drafts?" + $.param(uobj);
  var data = 
  {
    "Instances": [
      {
        "flow": "761f48a3-b29c-4dd2-ac20-fac76bf10c89",
        "applicant": "569c45ea6dd0ce005f000015",
        "space": "569c46246dd0ce005f000016"
      }
    ]
  };
  data = JSON.stringify(data);
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

// 拟稿状态下暂存instance（申请单）
UUflow_api.put_draft = function(instance) {
  var uobj = {};
  uobj.methodOverride = "PUT";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = "https://uuflowws.steedos.com/uf/drafts?" + $.param(uobj);
  var data = {"Instances":[instance]};
  data = JSON.stringify(data);
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
UUflow_api.delete_draft = function() {
  var uobj = {};
  uobj.methodOverride = "DELETE";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = "https://uuflowws.steedos.com/uf/drafts?" + $.param(uobj);
  var data = 
  { "Instances": 
    [
      {
      "id": "56cec163703f17006f000007"
      }
    ]
  };
  data = JSON.stringify(data);
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

// instance（申请单）的第一次提交
UUflow_api.post_submit = function() {
  var uobj = {};
  uobj.methodOverride = "POST";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = "https://uuflowws.steedos.com/uf/submit?" + $.param(uobj);
  var data = {"Instances":[{"space":"569c46246dd0ce005f000016","flow":"761f48a3-b29c-4dd2-ac20-fac76bf10c89","flow_version":"08bfb46b-1c48-4b06-9d36-7ec121307d0a","form":"0F7CBA0A-55D3-4E2C-90A9-031C1270F237","form_version":"db24b443-6ff5-4885-94be-db6b94b09931","name":"1","submitter":"569c45ea6dd0ce005f000015","submitter_name":"孙浩林","applicant":"569c45ea6dd0ce005f000015","applicant_name":"孙浩林","applicant_organization":"569c46246dd0ce005f000017","applicant_organization_name":"年华","applicant_organization_fullname":"年华","state":"draft","code":"","is_archived":false,"is_deleted":false,"inbox_users":[],"outbox_users":[],"modified":"2016-02-26T05:40:34Z","modified_by":"569c45ea6dd0ce005f000015","created":"2016-02-26T05:18:12Z","created_by":"569c45ea6dd0ce005f000015","traces":[{"instance":"56cfe0144b5bdf088d000001","previous_trace_ids":[],"is_finished":false,"step":"0315c03f-cd04-4fd3-9f80-d42aada92281","start_date":"2016-02-26T05:18:12Z","approves":[{"instance":"56cfe0144b5bdf088d000001","trace":"56cfe0144b5bdf088d000002","is_finished":false,"user":"569c45ea6dd0ce005f000015","user_name":"孙浩林","handler":"569c45ea6dd0ce005f000015","handler_name":"孙浩林","handler_organization":"569c46246dd0ce005f000017","handler_organization_name":"年华","handler_organization_fullname":"年华","type":"draft","start_date":"2016-02-26T05:18:12Z","read_date":"2016-02-26T05:18:12Z","judge":"submitted","is_read":true,"description":"11111111","values":{"勾选框":"false","数值":"33333333","日期":"2016-02-26"},"next_steps":[{"step":"90298dc2-eaf1-4715-a9cd-9465f425aede","users":["569c45ea6dd0ce005f000015"]}],"is_error":false,"id":"56cfe0144b5bdf088d000003"}],"id":"56cfe0144b5bdf088d000002"}],"attachments":[],"id":"56cfe0144b5bdf088d000001","judgeAction":"submit","is_sending":true}]};
  data = JSON.stringify(data);
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

// 审核状态下暂存instance（申请单）
UUflow_api.put_approvals = function(approve) {
  var uobj = {};
  uobj.methodOverride = "PUT";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = "https://uuflowws.steedos.com/uf/approvals?" + $.param(uobj);
  var data = {"Approvals":[approve]};
  data = JSON.stringify(data);
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
UUflow_api.post_engine = function() {
  var uobj = {};
  uobj.methodOverride = "POST";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = "https://uuflowws.steedos.com/uf/engine?" + $.param(uobj);
  var data = {"Approvals":[{"instance":"56cfe0144b5bdf088d000001","trace":"56cfe6044b5bdf088d000004","is_finished":false,"user":"569c45ea6dd0ce005f000015","user_name":"孙浩林","handler":"569c45ea6dd0ce005f000015","handler_name":"孙浩林","handler_organization":"569c46246dd0ce005f000017","handler_organization_name":"年华","handler_organization_fullname":"年华","start_date":"2016-02-26T05:43:32Z","due_date":"2016-03-04T05:43:32Z","read_date":"2016-02-26T05:46:07Z","judge":"approved","is_read":true,"description":"同意","values":{"勾选框":"false","数值":"33333333","日期":"2016-02-26"},"next_steps":[{"step":"1df215fb-881c-4bfe-83be-98bb1815c582","users":[]}],"is_error":false,"id":"56cfe6044b5bdf088d000005","attachments":[]}]};
  data = JSON.stringify(data);
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

UUflow_api.print = function(instanceId){
  window.open("http://192.168.0.23/uf/print?id=" + instanceId);
}
