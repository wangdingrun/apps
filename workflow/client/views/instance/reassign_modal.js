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
        $("#reassign_users").select2().val(null);

        $("#reassign_modal_text").val(null);

        var u = WorkflowManager.getSpaceUsers(Session.get("spaceId"));
        var s = InstanceManager.getCurrentStep();

        if (s.step_type == "counterSign") {
            $("#reassign_users").prop("multiple", "multiple");
            // $("#reassign_users").select2();
        } else {
            $("#reassign_users").removeAttr("multiple");
            // $("#reassign_users").select2();
        }

        u.forEach(function(user){
            $("#reassign_users").append("<option value='" + user.id + "'> " + user.name + " </option>");
        })

    },

    'click #reassign_modal_ok': function (event, template) {
        var reason = $("#reassign_modal_text").val();
        if (!reason) {
            $("#reassign_modal_warn").show();
            return;
        }

        var val = $("#reassign_users").select2().val();
        if (!val) {
            $("#reassign_modal_warn").show();
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

    'click #reassign_modal_close': function (event, template) {
        $('#reassign_modal_warn').hide();
    },

})