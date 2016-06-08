Template.masterLayout.onCreated ->
	self = this;

	self.minHeight = new ReactiveVar(
		$(window).height());

	$(window).resize ->
		self.minHeight.set($(window).height());


Template.masterLayout.onRendered ->

	if !Meteor.userId()
		FlowRouter.go "/steedos/sign-in"

	self = this;
	self.minHeight.set($(window).height());

	$('body').removeClass('fixed');



Template.masterLayout.helpers 
	minHeight: ->
		return Template.instance().minHeight.get() + 'px'
	