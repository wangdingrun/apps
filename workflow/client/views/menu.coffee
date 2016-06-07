Template.workflowMenu.helpers

    boxName: ->
        if Session.get("box")
            return t(Session.get("box"))

    inbox_count: ->
        c = db.box_counts.findOne(Session.get("spaceId"));
        if c && (c.inbox_count > 0)
            return c.inbox_count;
        return;

    draft_count: ->
        c = db.box_counts.findOne(Session.get("spaceId"));
        if c && (c.draft_count > 0)
            return c.draft_count;
        return;

    pending_count: ->
        c = db.box_counts.findOne(Session.get("spaceId"));
        if c && (c.progress_count > 0)
            return c.progress_count;
        return;

    completed_count: ->
        c = db.box_counts.findOne(Session.get("spaceId"));
        if c && (c.finished_count > 0)
            return c.finished_count;
        return;