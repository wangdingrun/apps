Template.registerHelpers = (dict) ->
    _.each dict, (v, k)->
        Template.registerHelper k, v

