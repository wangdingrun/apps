Router.route '/', ->
	if (!Meteor.userId())
		Router.go("/sign-in");



Router.route '/logout', ->
	AccountsTemplates.logout();


Router.route '/account/profile', ->
	if Meteor.user()
		this.render('profile');