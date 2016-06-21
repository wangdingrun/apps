Template.site_category_posts.helpers
    
    cms_category: ()->
        categoryId = this._id
        if categoryId
            return db.cms_categories.findOne(categoryId)
    cms_posts: ()->
        categoryId = this._id
        return db.cms_posts.find({category:categoryId})

Template.site_category_posts.events