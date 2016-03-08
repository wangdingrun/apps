Template.instance_list.helpers
		
	instances: ->
		return db.instances.find({}, {sort: {modified: -1}});

	boxName: ->
		return Session.get("box");

	spaceId: ->
		return Session.get("spaceId");

	selector: ->
		query = {space: Session.get("spaceId")}
		box = Session.get("box") 
		if box == "inbox"
			query.inbox_users = Meteor.userId();
		else if box == "outbox"
			query.outbox_users = Meteor.userId();
		else if box == "draft"
			query.submitter = Meteor.userId();
			query.state = "draft"
		else if box == "pending"
			query.submitter = Meteor.userId();
			query.state = "pending"
		else if box == "completed"
			query.submitter = Meteor.userId();
			query.state = "completed"
		else if box == "monitor"
			query.flow = flowId;
			query.state = {$in: ["pending","completed"]};
		else
			query.state = "none"

		return query

Template.instance_list.events

	'hidden.bs.modal #createInsModal': (event)->
		insId = Session.get("instanceId");
		if insId
			FlowRouter.go("/workflow/instance/" + insId);

	'click tbody > tr': (event) ->
		dataTable = $(event.target).closest('table').DataTable();
		rowData = dataTable.row(event.currentTarget).data();
		if (!rowData) 
			return; 
		FlowRouter.go("/workflow/instance/" + rowData._id)

