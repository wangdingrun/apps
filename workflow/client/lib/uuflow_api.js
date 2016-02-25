UUflow_api = {};

// 新建instance（申请单）
UUflow_api.post_draft = function() {
  var uobj = {};
  uobj.methodOverride = "POST";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = "https://uuflowws.steedos.com/uf/drafts?" + $.param(uobj);
  var data = { "Instances": 
    [{
      "flow": "761f48a3-b29c-4dd2-ac20-fac76bf10c89",
      "applicant": "569c45ea6dd0ce005f000015",
      "space": "569c46246dd0ce005f000016"
      }]
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
UUflow_api.put_draft = function() {
  var uobj = {};
  uobj.methodOverride = "PUT";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = "https://uuflowws.steedos.com/uf/drafts?" + $.param(uobj);
  var data = { "Instances": 
    [{
      "flow": "761f48a3-b29c-4dd2-ac20-fac76bf10c89",
      "applicant": "569c45ea6dd0ce005f000015",
      "space": "569c46246dd0ce005f000016"
      }]
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

// 拟稿状态下删除instance（申请单）
UUflow_api.delete_draft = function() {
  var uobj = {};
  uobj.methodOverride = "DELETE";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = "https://uuflowws.steedos.com/uf/drafts?" + $.param(uobj);
  var data = { "Instances": 
    [{
      "flow": "761f48a3-b29c-4dd2-ac20-fac76bf10c89",
      "applicant": "569c45ea6dd0ce005f000015",
      "space": "569c46246dd0ce005f000016"
      }]
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
  var url = "https://uuflowws.steedos.com/uf/submit?" + $param(uobj);
  var data = { "Instances": 
    [{
      "flow": "761f48a3-b29c-4dd2-ac20-fac76bf10c89",
      "applicant": "569c45ea6dd0ce005f000015",
      "space": "569c46246dd0ce005f000016"
      }]
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

// 审核状态下暂存instance（申请单）
UUflow_api.put_approvals = function() {
  var uobj = {};
  uobj.methodOverride = "PUT";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = "https://uuflowws.steedos.com/uf/approvals?" + $.param(uobj);
  var data = { "Instances": 
    [{
      "flow": "761f48a3-b29c-4dd2-ac20-fac76bf10c89",
      "applicant": "569c45ea6dd0ce005f000015",
      "space": "569c46246dd0ce005f000016"
      }]
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

// 待审核提交
UUflow_api.post_engine = function() {
  var uobj = {};
  uobj.methodOverride = "POST";
  uobj["X-User-Id"] = localStorage.getItem("Meteor.userId");
  uobj["X-Auth-Token"] = localStorage.getItem("Meteor.loginToken");
  var url = "https://uuflowws.steedos.com/uf/engine?" + $.param(uobj);
  var data = { "Instances": 
    [{
      "flow": "761f48a3-b29c-4dd2-ac20-fac76bf10c89",
      "applicant": "569c45ea6dd0ce005f000015",
      "space": "569c46246dd0ce005f000016"
      }]
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


