Template.relocate_modal.helpers({

    currentStepName: function () {
        var s = InstanceManager.getCurrentStep();
        if (s)
            return s.name;
        return "";
    },

})


Template.relocate_modal.events({

    'shown.bs.modal #relocate_modal': function (event) {
        $("#relocate_steps").select2();
        $("#relocate_steps").empty();
        $("#relocate_users").select2();
        $("#relocate_users").empty();
        
        var c = InstanceManager.getCurrentStep();
        var ins_steps = WorkflowManager.getInstanceSteps();
        if (ins_steps) {
            ins_steps.forEach(function(s){
                if (s.id != c.id && s.step_type != "condition") {
                    $("#relocate_steps").append("<option value= '" + s.id + "'> " + s.name + " </option>");
                }
            })
        }

        $("#relocate_steps").select2().val(null);
        $("#relocate_steps").select2().val();
        $("#relocate_users").select2().val(null);
        $("#relocate_users").select2().val();
        $("#relocate_modal_text").val(null);
    },

    'change #relocate_steps': function (event) {
        var v = $("#relocate_steps").select2().val();
        if (v) {
            var s = WorkflowManager.getInstanceStep(v);
            if (s.step_type == "start" || s.step_type == "end") {
                $("#relocate_users_p").css("display", "none");
            } else {
                var u = WorkflowManager.getSpaceUsers(Session.get("spaceId"));
                u.forEach(function(user){
                    $("#relocate_users").append("<option value='" + user.id + "'> " + user.name + " </option>");
                })
                $("#relocate_users").select2().val(null);
                $("#relocate_users").select2().val();

                $("#relocate_users_p").css("display","");
            }
            if (s.step_type == "counterSign") {
                $("#relocate_users").prop("multiple", "multiple");
            } else {
                $("#relocate_users").removeAttr("multiple");
            }
        } else {
            $("#relocate_users_p").css("display","");
        }
    },

    'click #relocate_modal_ok': function (event, template) {
        var sv = $("#relocate_steps").select2().val();
        if (!sv) {
            toastr.error("请选择步骤。");
            return;
        }

        var reason = $("#relocate_modal_text").val();
        if (!reason) {
            toastr.error("请填写重定位的理由。");
            return;
        }

        var uv = null;
        var s = WorkflowManager.getInstanceStep(sv);
        if (s.step_type == "start") {
            var instance = WorkflowManager.getInstance();
            if (instance) {
                uv = instance.applicant;
            }
        } else if (s.step_type == "end") {
            uv = [];
        } else {
            var uv = $("#relocate_users").select2().val();
        }

        if (s.step_type != "end" && !uv) {
            toastr.error("请指定处理人。");
            return;
        }

        var user_ids = [];
        if (uv instanceof Array) {
            user_ids = uv.getEach("value");
        } else {
            user_ids.push(uv);
        }

        InstanceManager.relocateIns(sv, user_ids, reason);
    },

})