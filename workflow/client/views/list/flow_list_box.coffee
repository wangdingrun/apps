Template.flow_list_box.helpers
    flow_list_data : ->
        return WorkflowManager.getFlowListData();

    empty: (categorie)->
        if !categorie.forms || categorie.forms.length < 1
            return false;
        return true;

    getGridWidth : ->
        if Steedos.isMobile()
            return "50%"

        return "33.33333333%";


Template.flow_list_box.events

    'click .flow_list_box .weui_grid': (event) ->
        flow = event.currentTarget.dataset.flow;

        console.log("newIns flow is " + flow)

        if !flow 
            return ;
        Modal.hide('flow_list_box_modal');    
        InstanceManager.newIns(flow);
