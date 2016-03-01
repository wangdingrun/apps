Template.flow_list.helpers({

  categories: function () {
    return WorkflowManager.getSpaceCategories();
  },

  categoryFlows: function (cateId) {
    var forms = db.forms.find({category:cateId});
    var flows = [];
    forms.forEach(function(f){
      db.flows.find({form:f._id}).forEach(function(fl){
        flows.push(fl)
      })
    });
    return flows;
  },

  notCategoryFlows: function () {
    var forms = db.forms.find({category:{$in:[null,""]}});
    var flows = [];
    forms.forEach(function(f){
      db.flows.find({form:f._id}).forEach(function(fl){
        flows.push(fl)
      })
    });
    return flows;
  },


});

Template.flow_list.events({

  "click [name='selectFlow']": function (event, template) {
    InstanceManager.newIns(event.target.id);
  },


})
