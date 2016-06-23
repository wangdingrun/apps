Package.describe({
    name: 'steedos:cms',
    version: '0.0.1',
    summary: 'Steedos CMS',
    git: ''
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
    api.use('underscorestring:underscore.string');
    api.use('tracker');
    api.use('session');
    api.use('blaze');
    
    api.use('simple:json-routes');
    api.use('nimble:restivus');
    api.use('aldeed:simple-schema');
    api.use('aldeed:collection2');
    api.use('aldeed:tabular');
    api.use('aldeed:autoform');
    api.use('matb33:collection-hooks');

    api.use('meteorhacks:ssr@2.2.0', 'server');


    api.use(['webapp'], 'server');


    api.use('tap:i18n', ['client', 'server']);
    //api.add_files("package-tap.i18n", ["client", "server"]);
    tapi18nFiles = ['i18n/en.i18n.json', 'i18n/zh-CN.i18n.json']
    api.addFiles(tapi18nFiles, ['client', 'server']);
    
    api.addFiles('lib/core.coffee');
    api.addFiles('lib/routes/site.coffee', 'server');
    api.addAssets('themes/default.html', 'server');

    // EXPORT
    api.export('CMS');
});

Package.onTest(function(api) {

});
