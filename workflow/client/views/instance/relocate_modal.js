Template.relocate_modal.helpers({

})


Template.relocate_modal.events({

    'click #relocate_modal_ok': function (event, template) {
        var reason = $("#relocate_modal_text").val();
        if (!reason) {
            $("#relocate_modal_warn").show();
            return;
        }

        // InstanceManager.terminateIns(reason);
    },

    'click #relocate_modal_close': function (event, template) {
        $('#relocate_modal_warn').hide();
    },

})