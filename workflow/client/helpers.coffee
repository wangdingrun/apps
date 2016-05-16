
Template.registerHelper 'urlPrefix', ->
        return __meteor_runtime_config__.ROOT_URL_PATH_PREFIX

Template.registerHelper 'isMobile', ->
        return $(window).width()<767