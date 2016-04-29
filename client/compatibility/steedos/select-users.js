AutoForm.addInputType("selectuser",{
    template:"afSelectUser",
    valueOut:function(){
        return this[0].dataset.values;
    },
    valueConverters:{
        "stringArray" : AutoForm.valueConverters.stringToStringArray,
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
    var data = {orgs:WorkflowManager.getSpaceOrganizations() , users:WorkflowManager.getSpaceUsers()};
    var values = $("input[name='"+template.data.name+"']")[0].dataset.values;

    var options = {};
    options.data = data;
    options.multiple = template.data.atts.multiple;
    if(values && values.length > 0){
        options.defaultValues = values.split(",");
    }
    SelectTag.show(options,"Template.afSelectUser.confirm('"+template.data.name+"')");
  }
});

Template.afSelectUser.confirm = function(name){
    var values = SelectTag.values;
    var valuesObject = SelectTag.valuesObject();
    if(valuesObject.length > 0){
        if($("input[name='"+name+"']")[0].multiple){
            $("input[name='"+name+"']").val(valuesObject.getProperty("name").toString());
            $("input[name='"+name+"']")[0].dataset.values = values;
        }else{
            $("input[name='"+name+"']").val(valuesObject[0].name);
            $("input[name='"+name+"']")[0].dataset.values = values[0];
        }
        
    }else{
        $("input[name='"+name+"']").val();
        $("input[name='"+name+"']")[0].dataset.values = '';
    }

}

Template.afSelectUser.rendered = function(){
    var value = this.data.value;
    var name = this.data.name;
    if(this.data.atts.multiple){
        $("input[name='"+name+"']").val(value ? value.getProperty("name").toString() : '');
        $("input[name='"+name+"']")[0].dataset.values = value ? value.getProperty("id") : '';
    }else{
        $("input[name='"+name+"']").val(value ? value.name : '');
        $("input[name='"+name+"']")[0].dataset.values = value ? value.id : ''; 
    }
    
}

