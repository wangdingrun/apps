@Steedos = @db = {}

db.users =  Meteor.users;
db.organizations = new Meteor.Collection('organizations');
db.spaces = new Meteor.Collection('spaces');
db.space_users = new Meteor.Collection('space_users');
