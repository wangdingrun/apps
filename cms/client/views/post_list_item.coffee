Template.cms_post_list_item.helpers

    body_preview: ->
        if this.summary
            return this.summary
        else if this.body
            return this.body.substring(0, 100)