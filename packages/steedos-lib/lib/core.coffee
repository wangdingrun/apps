###
# Kick off the global namespace for Steedos.
# @namespace Steedos
###

db = {}
Steedos = 
	settings: {}
	db: db

if Meteor.isClient

	Steedos.isMobile = ()->
		return $(window).width() < 767