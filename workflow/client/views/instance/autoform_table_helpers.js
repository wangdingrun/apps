autoform_table_Helpers = {};
Template.registerHelper("autoform_table_Helpers", autoform_table_Helpers);


autoform_table_Helpers.equals = function (a, b) {
  return a === b;
};

autoform_table_Helpers.unequals = function (a, b) {
  return a != b;
};

var get_table = function (tableCode){
    return $("[name='"+tableCode+"table']")[0];
};

autoform_table_Helpers.getTable = function (tableCode){
    //console.log("autoform_table dataset is " + JSON.stringify(get_table(tableCode).dataset));
    return get_table(tableCode).dataset;
};

autoform_table_Helpers.updateTable = function(tableCode, values){

    var table = get_table(tableCode);

    for(var key in values){
        table.dataset[key] = values[key];
    }

    return table;
};

var get_table_modal = function (tableCode){
    return $("[name='"+tableCode+".modal']")[0];
};

autoform_table_Helpers.updateTableModalFieldValue = function(fieldCode ,fieldType, value){

    if(fieldType == 'checkbox'){
        $("[name='" + fieldCode + "']")[0].checked = (value == 'true' || value) ? true: false;
    }else if(fieldType == 'radio'){
        $("input[type=radio][name='" + fieldCode + "'][value='"+value+"']").attr("checked","checked");
    }else if(fieldType =='multiSelect'){
        if (value && value.length > 0){
            value.forEach(function(v){
                $("input[name='" + fieldCode + "'][value='"+v+"']").attr("checked","checked");
            });
        }
    }else{
        $("[name='" + fieldCode + "']").val(value);
    }
};

autoform_table_Helpers.getTableModal = function (tableCode){
    //console.log("autoform_table modal dataset is " + JSON.stringify(get_table(tableCode).dataset));
    return get_table_modal(tableCode).dataset;
};

autoform_table_Helpers.getTableModalValue = function (fieldCode){
    var val = $("[name='" + fieldCode + "']").val()
    var type = $("[name='" + fieldCode + "']").attr("type")
    if(type == 'number'){
        val = val.to_float();
    }else if (type == 'checkbox'){
        val = $("[name='" + fieldCode + "']")[0].checked;
    }
    return val;
}

autoform_table_Helpers.updateTableModal = function (tableCode, values){
    var table_modal = get_table_modal(tableCode);

    for(var key in values){
        table_modal.dataset[key] = values[key];
    }

    return table_modal;
};

autoform_table_Helpers.showTableModal = function (tableCode, modalTitle){
    
    $("#"+tableCode+'-modal-header').html(modalTitle);

    $("#" + tableCode + "modal").modal('show');
};

autoform_table_Helpers.initValidrows = function (arr){
    var validrows = new Array();

    //if (!arr || arr.length < 1)
    //    arr = [-1] ;

    for(var i = 0 ; i < arr.length ; i++){
      validrows.push(i + "");
    }

    //console.log("initValidrows return values is " + validrows.toString());
    return validrows.toString();
};

autoform_table_Helpers.removeValidrows = function (validrows_str, row_index){
    var validrows = new Array();
    if (validrows_str !="")
        validrows = validrows_str.split(",");
    var id = validrows.indexOf(row_index);
    if (id > -1)
        validrows.splice(id,1);
    return validrows.toString();
};

autoform_table_Helpers.addValidrows = function (validrows_str, row_index){
    var validrows = new Array();
    if (validrows_str !="")
        validrows = validrows_str.split(",");
    validrows.push(row_index);
    return validrows.toString();
};

autoform_table_Helpers.getValidrowIndex = function (validrows_str, row_index){
    var validrows = new Array();
    if (validrows_str !="")
        validrows = validrows_str.split(",");
    return validrows.indexOf(row_index);
};

autoform_table_Helpers.update_row = function (row_index, tableCode, rowobj){
    $("[name='"+row_index+"row']").html(get_tds_html(row_index, tableCode, rowobj));
};

var get_tds_html = function(row_index, tableCode, rowobj){
    var tds_html = "<td>" + row_index + "</td>";

    for(var key in rowobj){

        switch(rowobj[key].type){
            case 'user' :
                tds_html = tds_html + "<td nowrap='nowrap'>" + WorkflowManager.getUser($("[name='"+(tableCode + ".$." + key)+"']").val()).name + "</td>";
                break;
            case 'group':
                tds_html = tds_html + "<td nowrap='nowrap'>" + WorkflowManager.getOrganization($("[name='"+(tableCode + ".$." + key)+"']").val()).name + "</td>";
                break;
            case 'checkbox':
                if ($("[name='"+(tableCode + ".$." + key)+"']")[0].checked)
                    tds_html = tds_html + "<td nowrap='nowrap'>" + '是' + "</td>";
                else
                    tds_html = tds_html + "<td nowrap='nowrap'>" + '否' + "</td>";
                break;
            case 'radio':
                tds_html = tds_html + "<td nowrap='nowrap'>" + $("[name='"+(tableCode + ".$." + key)+"']:checked").val() + "</td>";
                break;
            case 'multiSelect':
                var multiSelect_values = new Array();
                $("input[name='"+(tableCode + ".$." + key)+"']:checked").each(function(){
                    multiSelect_values.push($(this).val());
                });
                tds_html = tds_html + "<td nowrap='nowrap'>" + multiSelect_values.toString() + "</td>";
                break;
            case 'email':
                var fValue = $("[name='"+(tableCode + ".$." + key)+"']").val();
                fValue = fValue ? "<a href='mailto:"+fValue+"'>"+fValue+"</a>" : "";
                tds_html = tds_html + "<td nowrap='nowrap'>" + fValue + "</td>";
                break;
            case 'url':
                var fValue = $("[name='"+(tableCode + ".$." + key)+"']").val();
                fValue = fValue ?  "<a href='http://"+fValue+"' target='_blank'>http://"+fValue+"</a>" : "";
                tds_html = tds_html + "<td nowrap='nowrap'>" + fValue + "</td>";
                break;
            case 'password':
                tds_html = tds_html + "<td nowrap='nowrap'>******</td>";
                break;
            default:
                tds_html = tds_html + "<td nowrap='nowrap'>" + $("[name='"+(tableCode + ".$." + key)+"']").val() + "</td>";
                break;
        }
    };
    tds_html = tds_html + 
                    "<td nowrap='nowrap'>" + 
                        "<span class='panel-controls'>" + 
                            "<span class='glyphicon glyphicon-remove remove-steedos-table-row' data-rowindex='" + row_index + "' ></span>" +
                            "&nbsp;" + 
                            "<span class='glyphicon glyphicon-pencil edit-steedos-table-row' data-rowindex='" + row_index + "' data-title='修改' data-method='edit'></span>" +
                        "</span>" + 
                    "</td>";

    return tds_html;
};

var get_tr_html = function(row_index, tableCode, rowobj){

    var tr_html = "<tr class='person-row' data-toggle='modal' name='" + row_index + "row'>"; 

    tr_html = tr_html + get_tds_html(row_index, tableCode, rowobj);

    tr_html = tr_html + "</tr>";

    return tr_html;
};

autoform_table_Helpers.update_autoFormArrayItem = function(row_index, tableCode, rowobj){
    for(var key in rowobj){
        switch(rowobj[key].type){
            case 'checkbox':
                $("[name='"+(tableCode + "."+row_index+"." + key)+"']")[0].checked = $("[name='"+(tableCode + ".$." + key)+"']")[0].checked;
                break;
            case 'multiSelect':
                $("input[name='"+(tableCode + "."+row_index+"." + key)+"']").prop("checked",false);
                $("input[name='"+(tableCode + ".$." + key)+"']:checked").each(function(){
                    
                    $("input[name='"+(tableCode + "."+row_index+"." + key)+"'][value='"+$(this).val()+"']").prop("checked",true);
                });
                break;
            case 'radio':
                $("input[name='"+(tableCode + ".$." + key)+"']:checked").each(function(){
                    $("input[name='"+(tableCode + "."+row_index+"." + key)+"'][value='"+$(this).val()+"']").attr("checked","checked");
                });
                break;
            default:
                $("[name='"+(tableCode + "."+row_index+"." + key)+"']").val($("[name='"+(tableCode + ".$." + key)+"']").val());
                break;
        }
    }
};

autoform_table_Helpers.add_row = function (row_index, tableCode, rowobj){
    autoform_table_Helpers.update_autoFormArrayItem(row_index, tableCode, rowobj);

    var rows_html = $("#"+tableCode+'tbody').html() + get_tr_html(row_index, tableCode, rowobj);
    
    $("#"+tableCode+'tbody').html(rows_html);
};