Template.cms_post_list_item.helpers CMS.helpers

Template.cms_post_list_item.helpers
    PostSummary: ->
        if this.body
            return this.body.substring(0, 100)