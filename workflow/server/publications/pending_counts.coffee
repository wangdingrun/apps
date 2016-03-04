
Meteor.publish 'pending_counts', (spaceId)->
    
    unless this.userId
        return this.ready()
    
    unless spaceId
        return this.ready()

    console.log '[publish] pending_counts for space ' + spaceId

    self = this;
    count = 0;
    initializing = true;

    handle = db.instances.find({space: spaceId, state: "pending", inbox_users: this.userId}).observeChanges
        added: (id)->
            count++;
            if !initializing
                self.changed("pending_counts", spaceId, {pending_count: count});
        removed: (id)->
            count--;
            self.changed("pending_counts", spaceId, {pending_count: count});

    initializing = false;
    self.added("pending_counts", spaceId, {pending_count: count});
    self.ready();

    self.onStop ->
        handle.stop();
