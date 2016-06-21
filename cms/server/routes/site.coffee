Meteor.startup ->
    SSR.compileTemplate('site_home', Assets.getText('cms/site_home.html'));

JsonRoutes.add "get", "/site/:siteId",  (req, res, next) ->
    site = db.cms_sites.findOne({_id: req.params.siteId})
    
    html = SSR.render "site_home", 
        params: req.params
        site: site

    res.end(html);