Busboy = Npm.require('busboy');
Fiber = Npm.require('fibers');

JsonRoutes.parseFiles = (req, res, next) ->
		files = []; # Store files in an array and then pass them to request.
		image = {}; # crate an image object

		if (req.method == "POST") 
			busboy = new Busboy({ headers: req.headers });
			busboy.on "file",  (fieldname, file, filename, encoding, mimetype) ->
				image.mimeType = mimetype;
				image.encoding = encoding;
				image.filename = filename;

				# buffer the read chunks
				buffers = [];

				file.on 'data', (data) ->
					buffers.push(data);

				file.on 'end', () ->
					# concat the chunks
					image.data = Buffer.concat(buffers);
					# push the image object to the file array
					files.push(image);


			busboy.on "field", (fieldname, value) ->
				req.body[fieldname] = value;

			busboy.on "finish",  () ->
				# Pass the file array together with the request
				req.files = files;

				Fiber ()->
					next();
				.run();
			
			# Pass request to busboy
			req.pipe(busboy);
		
		else
			next();
		

#JsonRoutes.Middleware.use(JsonRoutes.parseFiles);

JsonRoutes.add "post", "/s3/",  (req, res, next) ->

	JsonRoutes.parseFiles req, res, ()->
		collection = cfs.instances

		if req.files and req.files[0]

			newFile = new FS.File();
			newFile.attachData req.files[0].data, {type: req.files[0].mimeType}, (err) ->
				newFile.name(req.files[0].filename);

				collection.insert newFile,  (err, fileObj) ->
					resp = {
						version_id: fileObj._id
						size: fileObj.size 
					};
					res.end(JSON.stringify(resp));
					return
		else
			res.statusCode = 500;
			res.end();

	 
JsonRoutes.add "delete", "/s3/",  (req, res, next) ->

	JsonRoutes.parseFiles req, res ()->

		collection = cfs.instances

		id = req.query.version_id;
		if id
			file = collection.findOne({ _id: id })
			if file
				file.remove()
				resp = {
					status: "OK"
				}
				res.end(JSON.stringify(resp));
				return

		res.statusCode = 404;
		res.end();

	 
JsonRoutes.add "get", "/s3/",  (req, res, next) ->

	id = req.query.version_id;

	res.statusCode = 302;
	res.setHeader "Location", "/api/files/instances/" + id + "?download=1"
	res.end();
