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
    {
      data: "name", 
      render:  (val, type, doc) ->
        modifiedString = moment(doc.modified).format('YY-MM-DD');
        return "<div class='instance-name'>" + doc.name + "</div><div class='instance-modified'>" + modifiedString + "</div><div class='instance-applicant'>" + doc.applicant_name + "</div>"
    },
    {
      data: "modified",
      visible: false,
    },
    {
      data: "applicant_name",
      visible: false,
    },
    {
      data: "applicant_organization_name",
      visible: false,
    }
    # {data: "applicant_name", title: "Applicant"},
    # {
    #   data: "modified",
    #   title: "Modified",
    #   render:  (val, type, doc) ->
    #     if (val instanceof Date) 
    #       modifiedString = moment(val).format('YY-MM-DD');
    #     	return "<div class='instance-modified'>" + modifiedString + "</div>"
    #     else 
    #     	return "";
    # },
    # {data: "applicant_organization_name", title: "Organization"},
  ],

  #select:
  #  style: 'single'
  dom: "tp",
  order:[[1,"desc"]]
  extraFields: ["form", "flow", "inbox_users", "outbox_users", "state", "space", "applicant", "form_version", "flow_version"],
  lengthChange: false,
  pageLength: 20,
  info: false,
  searching: true,
  responsive: 
    details: false
  autoWidth: false,

  #scrollY:        '400px',
  #scrollCollapse: true,
  pagingType: "numbers"

});