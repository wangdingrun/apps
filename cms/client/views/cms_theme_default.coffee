Template.cms_theme_default.helpers CMS.helpers

Template.cms_theme_default.events
	"click .navigation": (e, t)->
		a = $(e.target).closest('a');
		router = a[0]?.dataset["router"]
		if router
			NavigationController.go router