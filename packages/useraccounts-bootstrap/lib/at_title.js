// Simply 'inherites' helpers from AccountsTemplates
//Template.atTitle.helpers(AccountsTemplates.atTitleHelpers);

Template.atTitle.helpers({
  title: function() {
    return T9n.get("atTitle");
  },
})