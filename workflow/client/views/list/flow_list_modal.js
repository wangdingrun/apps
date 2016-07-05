Template.flow_list_modal.helpers({

});

Template.flow_list_modal.events({
  'shown.bs.modal #flow_list_modal': function(event) {
    var categories, data, forms;
    data = [];
    categories = WorkflowManager.getSpaceCategories();
    flow_id = Session.get("flowId");
    var curUserId = Meteor.userId();
    var canAdd_flow_ids = WorkflowManager.getMyCanAddFlows();
    var flow_ids = WorkflowManager.getMyAdminOrMonitorFlows();
    var space = db.spaces.findOne({'_id':Session.get('spaceId')});
    var box = Session.get('box');

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
          form: f._id,
          state: "enabled"
        }).forEach(function(fl) {
          var show = false;
          if (box == 'monitor') {
            if (space.admins.includes(curUserId) || flow_ids.includes(fl._id)) {
              show = true;
            }
          }

          if (canAdd_flow_ids.includes(fl._id)) {
            show = true;
          }

          if (!show) return;

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

        var show = false;
        if (box == 'monitor') {
          if (space.admins.includes(curUserId) || flow_ids.includes(fl._id)) {
            show = true;
          }
        }

        if (canAdd_flow_ids.includes(fl._id)) {
          show = true;
        }

        if (!show) return;

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

    $('#tree').treeview({
      data: [{text:TAPi18n.__('All flows'), nodes:data}]
    });
    $('#tree').on('nodeSelected', function(event, data) {
      if (data.flow_id) {
        Session.set("flowId", data.flow_id);  
      }
      else {
        Session.set("flowId", undefined);
      }
      Modal.hide('flow_list_modal');
    });
      
  },


})
