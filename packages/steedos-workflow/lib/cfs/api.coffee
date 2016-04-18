HTTP.methods
	"/s3/":
		"post": (data) ->
			collection = FS._collections["instances"];
			ref = {
				collection: collection,
			};
			return FS.HTTP.Handlers.PutInsert.apply(this, [ref]);

		"delete": (data) ->

			id = this.query.version_id;
			collection = FS._collections["instances"];
			file = null;
			if (id && collection)
				file = collection.findOne({ _id: id })

			ref = {
				collection: collection,
				file: file
			};

			if !ref.collection
				throw new Meteor.Error(404, "Not Found", "No collection found");

			if ref.file
				return FS.HTTP.Handlers.Del.apply(this, [ref]);
			else
				throw new Meteor.Error(404, "Not Found", 'No file found');


JsonRoutes.add "post", "/api/s3",  (req, res, next) ->
	formidable = Npm.require('formidable')
	form = new formidable.IncomingForm();

	form.parse req, (err, fields, files)->
		console.log(files)
 