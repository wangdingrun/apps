Template.space_switcher.helpers

	spaceCount: ->
		return Steedos.spaces.find().count()
		
	spaces: ->
		return Steedos.spaces.find();

	spaceName: ->
		if Session.get("spaceId")
			space = db.spaces.findOne(Session.get("spaceId"))
			if space
				return space.name
		return t("Workflow")


Template.space_switcher.events

	"click #switchSpace": ->
		self = this
		FlowRouter.go("/space/" + self._id + "/inbox/")
