Meteor.startup ->
	
	WebApp.connectHandlers.use '/avatar/', (req, res, next) ->
		this.params =
			userId: decodeURI(req.url).replace(/^\//, '').replace(/\?.*$/, '')

		user = db.users.findOne(this.params.userId);
		if !user
			res.writeHead 304
			res.end()
			return

		if user.avatar
			res.setHeader "Location", Meteor.absoluteUrl("/api/files/avatars/" + user.avatar)
			res.writeHead 302
			res.end()
			return

		if user.avatarURL
			res.setHeader "Location", user.avatarURL
			res.writeHead 302
			res.end()
			return

		username = user.name;
		if !username
			username = ""

		res.setHeader 'Content-Disposition', 'inline'

		if not file?
			res.setHeader 'content-type', 'image/svg+xml'
			res.setHeader 'cache-control', 'public, max-age=31536000'

			colors = ['#F44336','#E91E63','#9C27B0','#673AB7','#3F51B5','#2196F3','#03A9F4','#00BCD4','#009688','#4CAF50','#8BC34A','#CDDC39','#FFC107','#FF9800','#FF5722','#795548','#9E9E9E','#607D8B']

			position = username.length % colors.length
			color = colors[position]

			initials = ''
			if username.charCodeAt(0)>255
				initials = username.substr(0, 1)
			else
				initials = username.substr(0, 2)

			initials = initials.toUpperCase()

			svg = """
			<?xml version="1.0" encoding="UTF-8" standalone="no"?>
			<svg xmlns="http://www.w3.org/2000/svg" pointer-events="none" width="50" height="50" style="width: 50px; height: 50px; background-color: #{color};">
				<text text-anchor="middle" y="50%" x="50%" dy="0.36em" pointer-events="auto" fill="#ffffff" font-family="Helvetica, Arial, Lucida Grande, sans-serif" style="font-weight: 400; font-size: 28px;">
					#{initials}
				</text>
			</svg>
			"""

			res.write svg
			res.end()
			return

		reqModifiedHeader = req.headers["if-modified-since"];
		if reqModifiedHeader?
			if reqModifiedHeader == file.uploadDate?.toUTCString()
				res.setHeader 'Last-Modified', reqModifiedHeader
				res.writeHead 304
				res.end()
				return

		res.setHeader 'Last-Modified', file.uploadDate?.toUTCString() or new Date().toUTCString()
		res.setHeader 'content-type', 'image/jpeg'
		res.setHeader 'Content-Length', file.length

		file.readStream.pipe res
		return