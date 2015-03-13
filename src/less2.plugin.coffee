# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class Less2Plugin extends BasePlugin
		# Plugin name
		name: 'less2'

		# Plugin config
		config:
#			lessOptions:
#				compress: false
			environments:
				development:
					compress: false

		# Constructor
		constructor: ->
			# Prepare
			super
			docpad = @docpad
			config = @config

			# Require Less
			@less = require('less')

			# Chain
			@

		# Render
		# Called per document, for each extension conversion. Used to render one extension to another.
		render: (opts, next) ->
			# Prepare
			config = @config
			{inExtension,outExtension,file} = opts

			if inExtension is 'less'
				# Prepare
				lessOptions =
					filename: file.get('fullPath')

				# Extend
				((lessOptions[key] = value) for own key,value of config.lessOptions) if config.lessOptions

				# Render
				@less.render(opts.content, lessOptions).then ((output) ->
					# output.css = string of css
					opts.content = output.css

					# output.map = string of sourcemap

					# Add Reference Others if this document does
					# output.imports = array of string filenames of the imports referenced
					file.setMetaDefaults('referencesOthers': true)  if output.imports

					next()
				), (err) ->
					next new Error(err)

			else
				# Done, return back to DocPad
				return next()