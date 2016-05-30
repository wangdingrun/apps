AutoForm.addInputType("table",{
    template:"afTable",
    valueOut:function(){
        //return [{"选择部门2":"3333333333","选择部门2":"444444444444"}];//data-schema-key="{{this.name}}"
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

    changed : function(field_index){
        debugger;
        var formId = "instanceform";

        var field = field_index.split(".")[0];

        var index = field_index.split(".")[1];

        var keys = SteedosTable.getKeys(formId,field);

        if(keys.length < 1){
            return ;
        }
        
        var formValues = AutoForm.getFormValues(formId).insertDoc;
        var value ;
        if(formValues){
            value = formValues[field][index]
        }

        if(!value){
            return ;
        }

        return SteedosTable.getTr(keys, value, index);
    },

    getValueIndex : function(formId, table){
        var item_length = 1;

        if (AutoForm.arrayTracker.info[formId][name].array){
        
          item_length = AutoForm.arrayTracker.info[formId][name].array.length;
        
        }

        return item_length - 1;
    }
});


Template.autoForm.events({

    'change .form-control,.checkbox input,.af-radio-group input,.af-checkbox-group input': function(event, template){
        debugger;
        console.log("autoform_table form-control change");

        var name = event.target.name;
        var p = name.split(".")
        
        var table = p[0], index = p[1], field = p[2];

        var formId = "instanceform";

        var item_formula = JSON.parse($("#"+table+"Table")[0].dataset.item_formula);

        var form_values = AutoForm.getFormValues(formId).insertDoc;

        var item_values = form_values[table][index];

        var table_fields = WorkflowManager.getInstanceFields().findPropertyByPK("code",table).sfields;

        Form_formula.run(field, table + "."+ index + ".", item_formula, item_values, table_fields);

        SteedosTable.updateItem(formId, table, index);
    },

    'click .steedosTable-add-item': function(event, template) {
        event.preventDefault();

        // We pull from data attributes because the button could be manually
        // added anywhere, so we don't know the data context.
        var btn = $(event.currentTarget);
        var name = btn.attr("data-autoform-field");
        var minCount = btn.attr("data-autoform-minCount"); // optional, overrides schema
        var maxCount = btn.attr("data-autoform-maxCount"); // optional, overrides schema

        //var data = template.data;
        var formId = "instanceform"; //data && data.id;
        var ss = AutoForm.getFormSchema(formId);

        AutoForm.arrayTracker.addOneToField(formId, name, ss, minCount, maxCount);

        var item_length = 1;

        if (AutoForm.arrayTracker.info[formId][name].array){
        
          item_length = AutoForm.arrayTracker.info[formId][name].array.length;
        
        }
        setTimeout('SteedosTable.showModal(\'' + name + "Tbody_modal" + (item_length - 1) + '\')', 1);  //等待deps.changed执行完成后，执行弹出显示
    },

    'click .steedosTable-edit-item': function(event, template){
        debugger; 
        var name = event.currentTarget.dataset.field;
        var index = event.currentTarget.dataset.index;
        SteedosTable.showModal(name + "Tbody_modal" + index);
    },


    'click .steedosTable-remove-item': function(event, template){
        var self = this;
        var formId = "instanceform";
        
        var table = self.arrayFieldName;
        var index = self.index;

        AutoForm.arrayTracker.removeFromFieldAtIndex(formId, table, index, AutoForm.getFormSchema(formId),0,5000);

        setTimeout(function(){SteedosTable.removeItem(table, index)}, 1);
    },

    'click #steedosTable-close-modal': function(event, template){
        debugger;
        SteedosTable.hideModal();
    }
})



Template.afTable.rendered = function(){
    debugger;
    var formId = "instanceform";

    var field = this.data.name;

    var keys =  SteedosTable.getKeys(formId,field);

    var instanceFields = WorkflowManager.getInstanceFields();

    if(instanceFields){
        var fieldObject = instanceFields.findPropertyByPK("code",field);

        if(fieldObject){
            $("#"+field+"Table")[0].dataset.item_formula = JSON.stringify(Form_formula.getFormulaFieldVariable("Form_formula.field_values", fieldObject.sfields))
        }
    }
    

    $("#"+field+"Thead").html(SteedosTable.getThead(keys));
    debugger;

    $("#"+field+"Tbody").html(SteedosTable.getTbody(keys, field, this.data.value));  
};

SteedosTable = {};


SteedosTable.addItem = function(formId, field, index){
    var keys = SteedosTable.getKeys(formId,field);
    var form_values = AutoForm.getFormValues(formId).insertDoc;
    var item_values = form_values[field][index]
    $("#"+field+"Tbody").append(SteedosTable.getTr(keys, item_values, index, field));

}

SteedosTable.updateItem = function(formId, field, index){
    var item = $("#" + field + "_item_" + index);

    if(item && item.length > 0){
        var keys = SteedosTable.getKeys(formId,field);
        var form_values = AutoForm.getFormValues(formId).insertDoc;
        var item_values = form_values[field][index];
        var tds = "";
        keys.forEach(function(key){
            
            var value = item_values[key];

            tds = tds + SteedosTable.getTd(value);
            
        });

        item.empty();

        item.append(tds);

    }else{

        SteedosTable.addItem(formId, field, index);
    }
}

SteedosTable.removeItem = function(field, index){
    debugger;
    $("#" + field + "_item_" + index).remove();
    //AutoForm.arrayTracker.info[formId][name].array.remove(index);
}

SteedosTable.updateTbody = function(formId, field){
    var keys = SteedosTable.getKeys(formId,field);
    var form_values = AutoForm.getFormValues(formId).insertDoc;
    var field_value = form_values[field]
    $("#"+field+"Tbody").html(SteedosTable.getTbody(keys, field, field_value)); 
}

SteedosTable.showModal = function(modalId){
    var modal = $("#" + modalId)
    //$("body").append(modal);   //将弹出框添加到body下
    modal.modal("show");
}


SteedosTable.hideModal = function(modalId){
    var modal = $("#" + modalId);
    modal.modal("hide");
    //$("#"+modalId + "_tr").append(modal); //将弹出框放回原处，否则AutoForm取不到值
}

SteedosTable.getKeys = function(formId,field){
    if(!AutoForm.getCurrentDataForForm(formId)){
        return [];
    }

    var ss = AutoForm.getFormSchema(formId);

    var keys = [];

    if(ss.schema(field + ".$").type === Object){
        keys = ss.objectKeys(SimpleSchema._makeGeneric(field) + '.$')
    }
    
    return keys;
    
}

SteedosTable.getThead = function(keys){
    var thead = '', trs = '';

    keys.forEach(function(key){
        trs = trs + "<td>" + key + "</td>"
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

SteedosTable.getTr = function(keys, item_values, index, field){
    var tr = "<tr id='"+field+"_item_"+index+"' class='steedosTable-edit-item' data-index='" + index + "' data-field='" + field + "'>";
    var tds = "";
    keys.forEach(function(key){
        
        var value = item_values[key];

        tds = tds + SteedosTable.getTd(value);
        
    });
    tr = tr + tds + "</tr>";
    return tr;
}

SteedosTable.getTd = function(value){
    var td = "";
    if(value){
        if(value instanceof Array){
            if(value.length > 0){
                if(typeof(value[0]) === 'object'){
                    td = "<td>" + value.getProperty("name").toString() + "</td>"
                }else{
                    td = "<td>" + value.toString() + "</td>"
                }
                
            }else{
                td = "<td></td>"
            }
            
        }else if(typeof(value) === "object"){
            td = "<td>" + value.name + "</td>"
        }else{
            td = "<td>" + value + "</td>"
        }
    }else{
        td = "<td></td>"
    }
    return td;
}

SteedosTable.getTableHtml = function(keys,values){

    var table = '';

    var tableTitles = '', tableTitleTds = '', tableRows = '';

    keys.forEach(function(key){
        tableTitleTds = tableTitleTds + "<td>" + key + "</td>"
    });
    
    tableTitles = '<tr>' + tableTitleTds + '</tr>';
    

    values.forEach(function(rowValue){
        var row = "<tr>";
        var tds = "";
        keys.forEach(function(key){
            
            var value = rowValue[key];

            tds = tds + SteedosTable.getTdHtml(value);
            
        });
        row = row + tds + "</tr>"
        tableRows = tableRows + row;
    });

    table = tableTitles + tableRows

    return table;
}

