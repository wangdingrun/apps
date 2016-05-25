Template.reassign_modal.helpers({
    
    fields: function(){
        return new SimpleSchema({reassign_users:{autoform:{type:"selectuser"},optional:true,type:String,label:"处理人"}});
    },
    
    values: function(){
        return {};
    }
})


Template.reassign_modal.events({

    'show.bs.modal #reassign_modal': function (event) {
        
        var reassign_users = $("input[name='reassign_users']")[0];
        
        reassign_users.value = "";
        reassign_users.dataset.values = '';

        $("#reassign_modal_text").val(null);

        var s = InstanceManager.getCurrentStep();

        $("#reassign_currentStepName").html(s.name);

        if (s.step_type == "counterSign") {
            reassign_users.dataset.multiple = true;
        } else {
            reassign_users.dataset.multiple = false;
        }
    },

    'click #reassign_modal_ok': function (event, template) {
        var val = AutoForm.getFieldValue("reassign_users","reassign");
        if (!val) {
            toastr.error("请指定处理人。");
            return;
        }

        var reason = $("#reassign_modal_text").val();
        if (!reason) {
            toastr.error("请填写转签核的理由。");
            return;
        }

        var user_ids = val.split(",");

        InstanceManager.reassignIns(user_ids, reason);
    },


})