InstanceManager = {};

InstanceManager.getFormField = function(fieldId){
    var instanceFields = WorkflowManager.getInstanceFields();
    var field = instanceFields.filterProperty("_id", fieldId);

    if (field.length > 0){
        return field[0];
    }

    return null;
}

InstanceManager.getFormFieldValue = function(fieldCode){
    return AutoForm.getFieldValue(fieldCode, "instanceform");
};