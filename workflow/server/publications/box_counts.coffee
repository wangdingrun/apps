
Meteor.publish 'box_counts', (spaceId)->
    
    unless this.userId
        return this.ready()
    
    unless spaceId
        return this.ready()

    console.log '[publish] box_counts for space ' + spaceId

    self = this;
    inbox_count = 0;
    draft_count = 0;
    progress_count = 0;
    finished_count = 0;
    initializing = true;

    handle = db.instances.find({space: spaceId, state: "pending", inbox_users: this.userId}).observeChanges
        added: (id)->
            inbox_count++;
            if !initializing
                self.changed("box_counts", spaceId, {inbox_count: inbox_count});
        removed: (id)->
            inbox_count--;
            self.changed("box_counts", spaceId, {inbox_count: inbox_count});

    handle2 = db.instances.find({space: spaceId, state: "draft", submitter: this.userId}).observeChanges
        added: (id)->
            draft_count++;
            if !initializing
                self.changed("box_counts", spaceId, {draft_count: draft_count});
        removed: (id)->
            draft_count--;
            self.changed("box_counts", spaceId, {draft_count: draft_count});

    handle3 = db.instances.find({space: spaceId, state: "pending", submitter: this.userId}).observeChanges
        added: (id)->
            progress_count++;
            if !initializing
                self.changed("box_counts", spaceId, {progress_count: progress_count});
        removed: (id)->
            progress_count--;
            self.changed("box_counts", spaceId, {progress_count: progress_count});

    handle4 = db.instances.find({space: spaceId, state: "completed", submitter: this.userId, is_archived: false}).observeChanges
        added: (id)->
            finished_count++;
            if !initializing
                self.changed("box_counts", spaceId, {finished_count: finished_count});
        removed: (id)->
            finished_count--;
            self.changed("box_counts", spaceId, {finished_count: finished_count});

    initializing = false;
    self.added("box_counts", spaceId, {inbox_count: inbox_count, draft_count: draft_count, progress_count: progress_count, finished_count: finished_count});
    self.ready();

    self.onStop ->
        handle.stop();
        handle2.stop();
        handle3.stop();
        handle4.stop();




