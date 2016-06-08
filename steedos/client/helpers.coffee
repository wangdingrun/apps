Template.registerHelper 'urlPrefix', ->
    return __meteor_runtime_config__.ROOT_URL_PATH_PREFIX

Template.registerHelper 'isMobile', ->
    return $(window).width()<767

Template.registerHelper 'spaceId', ->
    if Session.get("spaceId")
        return Session.get("spaceId")
    else
        return "none";

Template.registerHelper 'locale', ->
    return Steedos.getLocale()