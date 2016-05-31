Template.steedosTableModal.helpers({
    getId : function (data) {
        debugger;
        return "steedos_table_modal_" + data.field.code + "_" + data.index;
    },

    getSchema : function  (data) {
        debugger;
        return new SimpleSchema(WorkflowManager_format.getTableItemSchema(data.field));
    },

})