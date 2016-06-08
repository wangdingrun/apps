Package.describe({
    name: 'steedos:meteor-cookie-login',
    version: '0.0.5',
    summary: 'Login to meteor apps with cookies',
    git: ''
});

Package.onUse(function(api) { 
    api.versionsFrom('1.0');

    api.use('coffeescript');
    api.use('accounts-base');

    api.addFiles('core.coffee', "client");


});

Package.onTest(function(api) {

});
