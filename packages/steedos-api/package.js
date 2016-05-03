Package.describe({
	name: 'steedos:api',
	version: '0.0.1',
	summary: 'Steedos api libraries',
	git: ''
});

Npm.depends({
  busboy: "0.2.13",
  cookies: "0.6.1",
  mime: "1.3.4"
});

Package.onUse(function(api) { 
	api.versionsFrom('1.0');


	api.use('reactive-var');
	api.use('reactive-dict');
	api.use('coffeescript');
	api.use('random');
	api.use('ddp');
	api.use('check');
	api.use('ddp-rate-limiter');
	api.use('underscore');
	api.use('tracker');
	api.use('session');
	api.use('accounts-base');
	api.use('sha');
	api.use('npm-bcrypt');

  	api.use('simple:json-routes');
	api.use('cfs:standard-packages');
	api.use('nimble:restivus');

	api.use('steedos:lib');
	api.use('steedos:workflow');

	api.use(['webapp'], 'server');

	api.addFiles('lib/URI.js');

	api.addFiles('core.coffee');

	api.addFiles('accounts_client.coffee', 'client');
	api.addFiles('routes/setup.coffee', 'server');
	api.addFiles('routes/s3.coffee', 'server');

});

Package.onTest(function(api) {

});
