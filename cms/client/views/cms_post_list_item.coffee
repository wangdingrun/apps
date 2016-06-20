Template.cms_post_list_item.helpers
    from_now: (posted)->
        return moment(posted).fromNow()
    body_preview: ->
        if this.summary
            return this.summary
        else if this.body
            return this.body.substring(0, 100)