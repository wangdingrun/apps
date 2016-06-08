Package.describe({
    name: 'steedos:meteor-cookie-login',
    version: '0.0.1',
    summary: 'Login to meteor apps with cookies',
    git: ''
});

Npm.depends({
  cookies: "0.6.1",
});

Package.onUse(function(api) { 
    api.versionsFrom('1.0');

    api.use('coffeescript');
    api.use('accounts-base');

    api.addFiles('core.coffee', "client");


});

Package.onTest(function(api) {

});
