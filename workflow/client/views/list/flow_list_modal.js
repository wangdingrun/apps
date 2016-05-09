Template.flow_list_modal.helpers({

});

Template.flow_list_modal.events({
  'shown.bs.modal #flow_list_modal': function(event) {
    var categories, data, forms;
    data = [];
    categories = WorkflowManager.getSpaceCategories();
    flow_id = Session.get("flowId");
    categories.forEach(function(cat) {
      var o;
      o = {};
      o.text = cat.name;
      o.nodes = [];
      o.selectable = false;
      o.state = {
        expanded: true
      };
      forms = db.forms.find({
        category: cat._id
      });
      forms.forEach(function(f) {
        db.flows.find({
          form: f._id
        }).forEach(function(fl) {
          if (flow_id == fl._id) {
            o.nodes.push({
              text: fl.name,
              flow_id: fl._id,
              state: {selected: true}
            });
          }
          else {
            o.nodes.push({
              text: fl.name,
              flow_id: fl._id
            });
          }
            
        });
      });
      data.push(o);
    });
    forms = db.forms.find({
      category: {
        $in: [null, ""]
      }
    });
    forms.forEach(function(f) {
      db.flows.find({
        form: f._id,
        state: "enabled"
      }).forEach(function(fl) {
        if (flow_id == fl._id) {
          data.push({
            text: fl.name,
            flow_id: fl._id,
            state: {selected: true}
          });
        }
        else {
          data.push({
            text: fl.name,
            flow_id: fl._id
          });
        }
      });
    });

    if (event.relatedTarget.name == "create_ins_btn") {
      $('#tree').treeview({
        data: data
      });
      $('#tree').on('nodeSelected', function(event, data) {
        InstanceManager.newIns(data.flow_id);
      });
      Session.set("flow_list_modal_type", "create");
    }
    else if (event.relatedTarget.name == "show_flows_btn") {
      $('#tree').treeview({
        data: [{text:"所有流程", nodes:data}]
      });
      $('#tree').on('nodeSelected', function(event, data) {
        if (data.flow_id) {
          Session.set("flowId", data.flow_id);  
        }
        else {
          Session.set("flowId", undefined);
        }
        $('#flow_list_modal').modal('hide');
      });
      Session.set("flow_list_modal_type", "show");
    }
      
  },


})
