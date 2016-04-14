db.instances = new Meteor.Collection('instances')

db.instances.helpers
	applicant_name: ->
		applicant = db.space_users.findOne({user: this.applicant});
		if applicant
			return applicant.name;
		else
			return ""


TabularTables.instances = new Tabular.Table({
  name: "instances",
  collection: db.instances,
  columns: [
    {data: "name", title: "Title"},
    {data: "applicant_name()", title: "Applicant"},
    {
      data: "modified",
      title: "Modified",
      render:  (val, type, doc) ->
        if (val instanceof Date) 
        	return moment(val).fromNow()
        else 
        	return "";
    },
  ],

  order:[[2,"desc"]]
  extraFields: ["form", "flow", "inbox_users", "outbox_users", "state", "space", "applicant", "form_version", "flow_version"],
  lengthChange: false,
  pageLength: 20,
  info: false,
  searching: true,
  responsive: true,
  autoWidth: false,
});