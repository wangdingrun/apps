AutoForm.addInputType("table",{
    template:"afTable",
    valueOut:function(){
        return "";
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

        debugger;

        return context;
    }
});

Template.afTable.helpers({

    // getTableKeys : function(tableCode){
    //     debugger;
    //     var ss = AutoForm.getFormSchema("instanceform");

    //     var keys = [];
        
    //     if(ss.schema(tableCode + ".$").type === Object){
    //         keys = ss.objectKeys(SimpleSchema._makeGeneric(tableCode) + '.$')
    //     }
    //     debugger;
    //     return keys;
    // }
});


Template.afTable.rendered = function(){

    debugger;

    var ss = AutoForm.getFormSchema("instanceform");

    var keys = [];
    
    var tableCode = this.data.name;
    
    if(ss.schema(tableCode + ".$").type === Object){
        keys = ss.objectKeys(SimpleSchema._makeGeneric(tableCode) + '.$')
    }
    
    

    this.data.atts.keys = keys
    
}