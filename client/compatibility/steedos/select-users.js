AutoForm.addInputType("selectuser",{
    template:"afSelectUser",
    valueOut:function(){
        return this.val();
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
        debugger;

        if(typeof context.atts.maxlength ==='undefined' && typeof context.max === 'number'){
            context.atts.maxlength = context.max;
        }

        context.atts.class = "selectUser form-control";

        context.atts.onclick = 'SelectTag.show({data:{orgs:WorkflowManager.getSpaceOrganizations() , users:WorkflowManager.getSpaceUsers()},multiple:false},\"$(\\\"input[name=\''+context.name+'\']\\\").val(SelectTag.values)\")';
        return context;
    }
});