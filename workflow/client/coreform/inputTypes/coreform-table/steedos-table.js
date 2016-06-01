
SteedosTable = {};

SteedosTable.formId = "instanceform";

SteedosTable.valueHash = {};

SteedosTable.checkItem = function(field, item_index){
    var fieldObj = SteedosTable.getField(field);

    var fieldVal = SteedosTable.getItemModalValue(field, item_index);

    var sf_name = '';
    var rev = true;
    fieldObj.sfields.forEach(function(sf){
        if(sf.permission == 'editable'){
            sf_name = fieldObj.code + "." + sf.code;
            if(!InstanceManager.checkFormFieldValue($("[name='"+sf_name+"']")[0])){
                rev = false;
            }
        }
    });

    return rev;
}


SteedosTable.getValidValue = function(field){
    var value = SteedosTable.valueHash[field];

    if(!value){
        return 
    }

    var validValue = [];

    value.forEach(function(v){
        if(!v.removed){
            validValue.push(v);
        }
    });

    return validValue;
}


SteedosTable.getField = function(field){
    var instanceFields =  WorkflowManager.getInstanceFields();
    if(!instanceFields)
        return ;

    var fieldObj = instanceFields.findPropertyByPK("code",field);

    return fieldObj;
}


SteedosTable.getModalData = function(field, index){

    var data = {};

    var fieldObj =  SteedosTable.getField(field);

    if(!fieldObj){
        return ;
    }

    data.field = fieldObj;

    data.field.formula = Form_formula.getFormulaFieldVariable("Form_formula.field_values", fieldObj.sfields);

    data.value = {};

    data.value[field] = SteedosTable.getItemValue(field, index);

    data.index = index ; 
    
    return data;
}

SteedosTable.getItemValue = function(field, item_index){
   
    return SteedosTable.valueHash[field][item_index];
}

SteedosTable.getItemModalValue = function(field, item_index){
    
    if(!AutoForm.getFormValues("steedos_table_modal_" + field + "_" + item_index)){
        return {}
    }

    var item_value = AutoForm.getFormValues("steedos_table_modal_" + field + "_" + item_index).insertDoc[field];
    return item_value;
}


SteedosTable.addItem = function(field, index){
    var keys = SteedosTable.getKeys(field);
    var item_value = SteedosTable.getItemModalValue(field, index);
    $("#"+field+"Tbody").append(SteedosTable.getTr(keys, item_value, index, field));

}

SteedosTable.updateItem = function(field, index){
    var item = $("#" + field + "_item_" + index);

    var item_value = SteedosTable.getItemModalValue(field, index);

    if(item && item.length > 0){
        var keys = SteedosTable.getKeys(field);
        var tds = "";
        
        var sfields = SteedosTable.getField(field).sfields;

        keys.forEach(function(key){
            var sfield = sfields.findPropertyByPK("code",key);
            
            var value = item_value[key];

            tds = tds + SteedosTable.getTd(sfield, value);
            
        });

        item.empty();

        item.append(tds);

    }else{

        SteedosTable.addItem(field, index);
    }

    if(SteedosTable.valueHash[field]){

        SteedosTable.valueHash[field][index] = item_value;
    
    }else{
        SteedosTable.valueHash[field] = [item_value];

    }

    //执行主表公式计算
    InstanceManager.runFormula(field);
    
}

SteedosTable.removeItem = function(field, index){
    
    $("#" + field + "_item_" + index).hide();

    SteedosTable.valueHash[field][index]["removed"] = true;

    InstanceManager.runFormula(field);
}

SteedosTable.showModal = function(field, index, method){


    var modalData = SteedosTable.getModalData(field, index);

    modalData.method = method;

    Modal.show("steedosTableModal", modalData);

}

SteedosTable.getKeys = function(field){
    if(!AutoForm.getCurrentDataForForm(SteedosTable.formId)){
        return [];
    }

    var ss = AutoForm.getFormSchema(SteedosTable.formId);

    var keys = [];

    if(ss.schema(field + ".$").type === Object){
        keys = ss.objectKeys(SimpleSchema._makeGeneric(field) + '.$')
    }
    
    return keys;
    
}

SteedosTable.getThead = function(field){

    var fieldObj = SteedosTable.getField(field);

    if(!fieldObj){
        return '';
    }

    var thead = '', trs = '', label = '', width = 100;

    var sfields = fieldObj.sfields;

    var sf_length = sfields.length;

    if(sf_length > 0){
        var wide_fields = sfields.filterProperty("is_wide",true);

        width = 100 / (sf_length + wide_fields.length);
    }

    sfields.forEach(function(sf,index){

        label = (sf.name !=null && sf.name.length > 0) ? sf.name : sf.code ;

        trs = trs + "<td nowrap='nowrap' ";
        if(index != (sf_length - 1)){
            if(sf.is_wide){
                trs = trs + "style='min-width:120px;width:" + width*2 + "%'"
            }else{
                trs = trs + "style='min-width:120px;width:" + width + "%'"
            }
        }

        trs = trs + ">" + label + "</td>"
    });
    
    thead = '<tr>' + trs + '</tr>';

    return thead;
}

SteedosTable.getTbody = function(keys, field, values){
    var tbody = "";

    if(values instanceof Array){
        values.forEach(function(value,index){
            tbody = tbody + SteedosTable.getTr(keys, value, index, field);
        });
    }

    return tbody;
}

SteedosTable.getTr = function(keys, item_value, index, field){
    var tr = "<tr id='"+field+"_item_"+index+"' class='steedosTable-edit-item' data-index='" + index + "' data-field='" + field 

    if(item_value.removed){
        tr = tr + " style='display:none' ";
    }

    tr = tr + "'>";
    var tds = "";

    var sfields = SteedosTable.getField(field).sfields;

    keys.forEach(function(key){
        var sfield = sfields.findPropertyByPK("code",key);
        
        var value = item_value[key];

        tds = tds + SteedosTable.getTd(sfield, value);
        
    });
    tr = tr + tds + "</tr>";
    return tr;
}

SteedosTable.getTd = function(field, value){
    var td = "";
    if(value){
        td = "<td>" + SteedosTable.getTDValue(field, value) + "</td>"
    }else{
        td = "<td></td>"
    }
    return td;
}


SteedosTable.getTDValue = function(field, value){
    var td_value = "";
    if(!field || !value){
        return td_value
    }

    switch(field.type){
        case 'user' :

            if(field.is_multiselect){
                if(value.length > 0){
                    if("string" == typeof(value[0])){
                        td_value = WorkflowManager.getUsers(value).getProperty("name").toString();
                    }else{
                        td_value = value.getProperty("name").toString();
                    } 
                }
            }else{
                if("string" == typeof(value)){
                    td_value = WorkflowManager.getUser(value).name
                }else{
                    td_value = value.name;
                } 
            }   
            break;
        case 'group':

            if(field.is_multiselect){
                if(value.length > 0){
                    if("string" == typeof(value[0])){
                        td_value = WorkflowManager.getOrganizations(value).getProperty("name").toString();
                    }else{
                        td_value = value.getProperty("name").toString();
                    } 
                }
            }else{
                if("string" == typeof(value)){
                    td_value = WorkflowManager.getOrganization(value).name;
                }else{
                    td_value = value.name;
                } 
            }   
            break;
        case 'checkbox':
            if (value){
                td_value = '是';
            }else{
                td_value = '否';
            }
            break;
        case 'email':
            td_value = value ? "<a href='mailto:"+value+"'>"+value+"</a>" : "";
            break;
        case 'url':
            td_value = value ?  "<a href='http://"+value+"' target='_blank'>http://"+value+"</a>" : "";
            break;
        case 'password':
            td_value = '******';
            break;
        case 'date':
            if(value){
                td_value = $.format.date(value,'yyyy-MM-dd');
            }
            break;
        case 'dateTime':
            if(value){
                td_value = $.format.date(value,'yyyy-MM-dd HH:mm');
            }
            break;
        default:
            td_value = value;
            break;
    }
    return td_value;
};


AutoForm.addInputType("table",{
    template:"afTable",
    valueOut:function(){
        var name = this.data("schemaKey");
        return SteedosTable.getValidValue(name);
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

        return context;
    }
});


Template.afTable.events({
    'click .steedosTable-add-item': function(event, template) {
       
        var name = template.data.name;

        var new_item_index = SteedosTable.valueHash[name] ? SteedosTable.valueHash[name].length : 0;

        SteedosTable.showModal(name, new_item_index, "add");
    },

    'click .steedosTable-edit-item': function(event, template){
        debugger; 
        var name = event.currentTarget.dataset.field;
        var index = event.currentTarget.dataset.index;
        SteedosTable.showModal(name, index, "edit");
    }
});




Template.afTable.rendered = function(){
    debugger;

    var field = this.data.name;

    var keys =  SteedosTable.getKeys(field);
    
    SteedosTable.valueHash[field] = this.data.value;

    $("#"+field+"Thead").html(SteedosTable.getThead(field));
    debugger;

    $("#"+field+"Tbody").html(SteedosTable.getTbody(keys, field, this.data.value));  
};

