@T9n = {}

T9n.get = (key) ->
        if key
                return TAPi18n.__ key
        else
                return ""


T9n.setLanguage = () ->
        # do nothing