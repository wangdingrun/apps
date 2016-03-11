Template.force_end_modal.helpers({

})


Template.force_end_modal.events({

    'click #force_end_modal_ok': function (event, template) {
        var reason = $("#force_end_modal_text").val();
        if (!reason) {
            toastr.error("请填写取消申请的理由。");
            return;
        }

        InstanceManager.terminateIns(reason);
    },

})