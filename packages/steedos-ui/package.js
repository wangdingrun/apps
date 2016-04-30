Package.describe({
        name: 'steedos:ui',
        version: '0.0.1',
        summary: 'Steedos ui',
        git: ''
});

Package.onUse(function(api) { 
        api.versionsFrom('1.0');

        api.use(['session','jquery','templating'],'client')

        // COMMON
        api.addFiles('views/loading.html', 'client');
        api.addFiles('views/loading.css', 'client');

});

Package.onTest(function(api) {

});
