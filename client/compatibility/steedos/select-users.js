AutoForm.addInputType("selectuser",{
    template:"afSelectUser",
    valueOut:function(){
        debugger;
        return this.data.values;
    },
    valueConverters:{
        "stringArray" : function (val) {
          return [];
        },
        "number" : AutoForm.valueConverters.stringToNumber,
        "numerArray" : AutoForm.valueConverters.stringToNumberArray,
        "boolean" : AutoForm.valueConverters.stringToBoolean,
        "booleanArray" : AutoForm.valueConverters.stringToBooleanArray,
        "date" : AutoForm.valueConverters.stringToDate,
        "dateArray" : AutoForm.valueConverters.stringToDateArray
    },
    contextAdjust: function(context){

        if(typeof context.atts.maxlength ==='undefined' && typeof context.max === 'number'){
            context.atts.maxlength = context.max;
        }

        context.atts.class = "selectUser form-control";

        //context.atts.onclick = 'SelectTag.show({data:{orgs:WorkflowManager.getSpaceOrganizations() , users:WorkflowManager.getSpaceUsers()},multiple:false},\"$(\\\"input[name=\''+context.name+'\']\\\").val(SelectTag.values)\")';
        return context;
    }
});



Template.afSelectUser.events({
  'click .selectUser': function (event, template) {
    debugger
    var data = {orgs:WorkflowManager.getSpaceOrganizations() , users:WorkflowManager.getSpaceUsers()};
    var values = $("input[name='"+template.data.name+"']").data.values;

    var options = {};
    options.data = data;
    options.multiple = false;
    if(values && values.length > 0){
        options.defaultValues = (values instanceof Array) ? values : [values];
    }
    SelectTag.show(options,"Template.afSelectUser.confirm('"+template.data.name+"')");
  }
});

Template.afSelectUser.confirm = function(name){
    var template = this;
    var values = SelectTag.values;
    var valuesObject = SelectTag.valuesObject();
    if(valuesObject.length > 0){
        $("input[name='"+name+"']").val(valuesObject[0].name);
        $("input[name='"+name+"']").data.values = values[0];
    }else{
        $("input[name='"+name+"']").val();
    }

}