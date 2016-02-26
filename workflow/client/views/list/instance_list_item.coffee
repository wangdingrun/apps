Template.instance_list_item.helpers
	momentModified: ->
		return moment(this.modified).fromNow()