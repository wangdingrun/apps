Template.space_select.helpers
        spaces: ()->
                return db.spaces.find()
                
        urlPrefix: ->
                return __meteor_runtime_config__.ROOT_URL_PATH_PREFIX
                