Template.space_switcher.helpers

	spaceCount: ->
		return db.spaces.find().count()
		
	spaces: ->
		return db.spaces.find();

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
