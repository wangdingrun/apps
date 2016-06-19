Template.registerHelper 'absoluteUrl', ->
	return Meteor.absoluteUrl()

Template.registerHelper 'urlPrefix', ->
	return __meteor_runtime_config__.ROOT_URL_PATH_PREFIX

# Template.body.events
# 	"click #navigation-back": (e, t) ->
# 		NavigationController.back(); 
