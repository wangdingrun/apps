Template.reassign_modal.helpers({

    currentStepName: function () {
        var s = InstanceManager.getCurrentStep();
        if (s)
            return s.name;
        return "";
    },

})


Template.reassign_modal.events({

    'shown.bs.modal #reassign_modal': function (event) {
        $("#reassign_users").select2();
        $("#reassign_users").empty();
        $("#reassign_modal_text").val(null);

        var u = WorkflowManager.getSpaceUsers(Session.get("spaceId"));
        var s = InstanceManager.getCurrentStep();

        if (s.step_type == "counterSign") {
            $("#reassign_users").prop("multiple", "multiple");
        } else {
            $("#reassign_users").removeAttr("multiple");
        }

        u.forEach(function(user){
            $("#reassign_users").append("<option value='" + user.id + "'> " + user.name + " </option>");
        })

        $("#reassign_users").select2().val(null);
        $("#reassign_users").select2().val();
    },

    'click #reassign_modal_ok': function (event, template) {
        var val = $("#reassign_users").select2().val();
        if (!val) {
            toastr.error("请指定处理人。");
            return;
        }

        var reason = $("#reassign_modal_text").val();
        if (!reason) {
            toastr.error("请填写转签核的理由。");
            return;
        }

        var user_ids = [];
        if (val instanceof Array) {
            user_ids = val.getEach("value");
        } else {
            user_ids.push(val);
        }

        InstanceManager.reassignIns(user_ids, reason);
    },


})