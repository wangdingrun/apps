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
		return t("Select Space")


Template.space_switcher.events

	"click #switchSpace": ->
		self = this
		Meteor.call "setSpaceId", self._id, ->
			Session.set("spaceId", self._id)
			#FlowRouter.go("/workflow/inbox/" + self._id)
