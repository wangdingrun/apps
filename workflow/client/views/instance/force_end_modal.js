Template.force_end_modal.helpers({

})


Template.force_end_modal.events({

    'click #force_end_modal_ok': function (event, template) {
        var reason = $("#force_end_modal_text").val();
        if (!reason) {
            $("#force_end_modal_warn").show();
            return;
        }

        InstanceManager.terminateIns(reason);
    },

    'click #force_end_modal_close': function (event, template) {
        $('#force_end_modal_warn').hide();
    },

    'hidden.bs.modal #force_end_modal': function (event, template) {
        FlowRouter.go("/workflow/pending/" + Session.get("spaceId"));
    }



})