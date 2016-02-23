var ROWOBJ = {};

Template.autoform_table.helpers({

  equals: function(a,b) {
    return autoform_table_Helpers.equals(a,b);
  },

  unequals: function(a,b) {
    return autoform_table_Helpers.unequals(a,b);
  },

  append: function(a,b) {
    return a + b ;
  },

  initValidrows: function(arr){
    return autoform_table_Helpers.initValidrows(arr);
  },

  initRowobj: function(sfield){

    var rowObj = {};
    for(var i = 0 ; i < sfield.length ; i++){
      rowObj[sfield[i].code] = {value:'',type:sfield[i].type};
    }
    ROWOBJ = rowObj;
    return JSON.stringify(rowObj);
  },

  initRowFormula: function(sfield){
    var formulas = Form_formula.getFormulaFieldVariable("Form_formula.field_values", sfield);
    console.log("autoform_table formulas is \n" + JSON.stringify(formulas));
    return JSON.stringify(formulas);
  },

  arrayify: function (obj){
      var result = [];
      var fValue;
      for(var key in obj){
        fValue = obj[key];
        switch(ROWOBJ[key].type){
          case 'user':
              fValue = fValue ? fValue.name : '';
            break;
          case 'group':
            fValue = fValue ? fValue.name : '';
            break;
          case 'email':
            fValue = fValue ? "<a href='mailto:"+fValue+"'>"+fValue+"</a>" : "";
            break;
          case 'url':
            fValue = fValue ?  "<a href='http://"+fValue+"' target='_blank'>http://"+fValue+"</a>" : "";
            break;
          case 'password':
            fValue = "******";
            break;
          default:
            fValue = obj[key];
            break;
        }
        result.push({code:key, value:fValue});
      }
      return result;
  }

});

Template.autoform_table.events({
    'click .add-steedos-table-row': function (event, template) {

      var tableCode = template.data.code;
      
      var steedosTable = autoform_table_Helpers.getTable(tableCode);

      var formId = steedosTable.formid;

      var rowObj = JSON.parse(steedosTable.rowobj);

      //获取新增行的index;
      var row_index
      if (AutoForm.arrayTracker.info[formId][tableCode].array){
        row_index = AutoForm.arrayTracker.info[formId][tableCode].array.length;
      }else{
        row_index = 0;
      }
      //var row_index = AutoForm.arrayTracker.info[formId][tableCode].count;

      for(var key in rowObj){
        autoform_table_Helpers.updateTableModalFieldValue(tableCode + ".$." + key, rowObj[key].type, rowObj[key].value);
      }
      
      AutoForm.arrayTracker.addOneToField(formId, tableCode, AutoForm.getFormSchema(formId),0,5000);

      autoform_table_Helpers.updateTable(tableCode, {"validrows" : autoform_table_Helpers.addValidrows(steedosTable.validrows, row_index)});

      autoform_table_Helpers.updateTableModal(tableCode, {"rowindex" : row_index, "method" : event.target.dataset.method});

      autoform_table_Helpers.showTableModal(tableCode , event.target.dataset.title);
    },

    'click .remove-steedos-table-row': function (event, template) {

      var tableCode = template.data.code;

      var steedosTable = autoform_table_Helpers.getTable(tableCode);

      var row_index = event.target.dataset.rowindex;

      var formId = steedosTable.formid;

      AutoForm.arrayTracker.removeFromFieldAtIndex(formId, tableCode, row_index, AutoForm.getFormSchema(formId),0,5000);

      //隐藏删除行
      $("[name='"+row_index+"row']").css("display","none");
      
      //steedosTable.dataset.validrows = autoform_table_Helpers.removeValidrows(steedosTable.dataset.validrows, row_index);

      autoform_table_Helpers.updateTable(tableCode, {"validrows" : autoform_table_Helpers.removeValidrows(steedosTable.validrows, row_index)});
    },

    'click .edit-steedos-table-row': function (event, template) {

        var row_index = event.target.dataset.rowindex;

        var tableCode = template.data.code;

        var steedosTable = autoform_table_Helpers.getTable(tableCode);

        var formId = steedosTable.formid;

        var rowObj = JSON.parse(steedosTable.rowobj);

        var value_index = autoform_table_Helpers.getValidrowIndex(steedosTable.validrows, row_index);

        var rowValue = AutoForm.getFieldValue(tableCode, formId)[value_index];

        console.log("edit-steedos-table-row , rowValue is " + JSON.stringify(rowValue));
        debugger;
        for(var key in rowObj){
          autoform_table_Helpers.updateTableModalFieldValue(tableCode + ".$." + key, rowObj[key].type, rowValue[key]);
        }

        autoform_table_Helpers.updateTableModal(tableCode, {"rowindex" : row_index, "method" : event.target.dataset.method});

        autoform_table_Helpers.showTableModal(tableCode , event.target.dataset.title);
    },

    'change .form-control,.checkbox input,.af-radio-group input,.af-checkbox-group input': function(event, template){

      console.log("autoform_table form-control change");

      var fieldCode = event.target.name;

      console.log("change fieldCode is " + fieldCode)

      var tableCode = template.data.code;

      var steedosTable = autoform_table_Helpers.getTable(tableCode);

      var steedosTableModal = autoform_table_Helpers.getTableModal(tableCode);

      var rowObj = JSON.parse(steedosTable.rowobj);

      var rowIndx = steedosTableModal.rowindex;

      var rowFormula = JSON.parse(steedosTable.rowformula);

      var rowValue = {};

      if (rowIndx < 0) 
        return ;
      
      for(var key in rowObj){
        rowValue[key] = autoform_table_Helpers.getTableModalValue(tableCode + ".$." + key);
      }

      console.log("fieldCode is " + fieldCode + "; rowValue is \n" + JSON.stringify(rowValue));

      Form_formula.run(fieldCode.split(".")[2], tableCode + ".$.", rowFormula, rowValue, template.data.sfields);

      autoform_table_Helpers.update_autoFormArrayItem(rowIndx, tableCode, rowObj);
    },

    'click #steedos-table-ok-button': function(event, template){
      
      var tableCode = template.data.code;

      var steedosTable = autoform_table_Helpers.getTable(tableCode);

      var steedosTableModal = autoform_table_Helpers.getTableModal(tableCode);

      var row_index = steedosTableModal.rowindex;
      
      var rowobj = JSON.parse(steedosTable.rowobj);

      var call_method = steedosTableModal.method;
      if(call_method == "add"){
        autoform_table_Helpers.add_row(row_index, tableCode, rowobj);
      }

      if(call_method == "edit"){
        autoform_table_Helpers.update_row(row_index, tableCode, rowobj);
      }
    }
})