gulp = require 'gulp'
gutil = require 'gulp-util'
# connect = require 'gulp-connect'
# jade = require 'gulp-jade'
concat = require 'gulp-concat'
clean = require 'gulp-clean'
stylus = require 'gulp-stylus'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
minifyCss = require 'gulp-minify-css'

nib = require 'nib'

browserify = require 'browserify'
watchify = require 'watchify'
# connectRewrite = require './connect-rewrite'
source = require 'vinyl-source-stream'
# reactify = require 'reactify'
# brfs = require 'brfs'
# bodyParser = require 'body-parser'
# psi = require 'psi'
# console.log bodyParser()
async = require 'async'
rimraf = require 'rimraf'

browserSync = require 'browser-sync'
reload = browserSync.reload
proxy = require 'proxy-middleware'
modRewrite = require 'connect-modrewrite'
url = require 'url'

compiledDir = './compiled'
distDir = './dist'
paths =
	coffee: [
		'./src/coffee/**/*.coffee'
		'./node_modules/elaborate-modules/modules/**/*.coffee'
		'./node_modules/hilib/src/**/*.coffee'
		'./node_modules/faceted-search/src/coffee/**/*.coffee'
	]
	jade: [
		'./src/index.jade'
	]
	stylus: [
		'./node_modules/hilib/src/views/**/*.styl'
		'./node_modules/faceted-search/src/stylus/**/*.styl'
		'./node_modules/elaborate-modules/modules/**/*.styl'
		'./src/stylus/**/*.styl'
	]

gulp.task 'server', ['watch', 'watchify'], ->
	proxyOptions = url.parse('http://localhost:3000')
	proxyOptions.route = '/api'
	
	browserSync.init null,
		notify: false
		server:
			baseDir: compiledDir
			middleware: [
				proxy(proxyOptions),
				modRewrite([
					'^[^\\.]*$ /index.html [L]'
				])
			]

gulp.task 'link', (done) ->
	removeModules = (cb) ->
		modulePaths = cfg['local-modules'].map (module) -> "./node_modules/#{module}"
		async.each modulePaths , rimraf, (err) -> cb()

	linkModules = (cb) ->
		moduleCommands = cfg['local-modules'].map (module) -> "npm link #{module}"
		async.each moduleCommands, exec, (err) -> cb()

	async.series [removeModules, linkModules], (err) ->
		return gutil.log err if err?
		done()

gulp.task 'unlink', (done) ->
	unlinkModules = (cb) ->
		moduleCommands = cfg['local-modules'].map (module) -> "npm unlink #{module}"
		async.each moduleCommands, exec, (err) -> cb()

	installModules = (cb) ->
		exec 'npm i', cb

	async.series [unlinkModules, installModules], (err) ->
		return gutil.log err if err?
		done()

# gulp.task 'connect', connect.server
# 	root: compiledDir,
# 	port: 9000,
# 	livereload: true
# 	middleware: (connect, options) -> [bodyParser(), connectRewrite(connect, options)]

# gulp.task 'connect-dist', connect.server
# 	root: distDir,
# 	port: 9002,
# 	middleware: connectRewrite

gulp.task 'jade', ->
	gulp.src(paths.jade)
		.pipe(jade())
		.pipe(gulp.dest(compiledDir))
		.pipe(reload())

# gulp.task 'browserify', ->
# 	gulp.src('./src/coffee/main.cjsx', read: false)
# 		.pipe(browserify(
# 			transform: ['coffee-reactify']
# 			# extensions: ['.coffee', '.jade']
# 		))
# 		.pipe(rename(extname:'.js'))
# 		.pipe(gulp.dest(compiledDir+'/js'))
# 		.pipe(reload())

gulp.task 'stylus', ->
	gulp.src(paths.stylus)
		.pipe(stylus(
			use: ['nib']
		))
		.pipe(concat('main.css'))
		.pipe(gulp.dest(compiledDir+'/css'))
		.pipe(reload(stream: true))

gulp.task 'uglify', ->
	gulp.src(compiledDir+'/js/main.js')
		.pipe(uglify())
		.pipe(gulp.dest(distDir+'/js'))

gulp.task 'minify-css', ->
	gulp.src(compiledDir+'/css/main.css')
		.pipe(minifyCss())
		.pipe(gulp.dest(distDir+'/css'))

gulp.task 'clean-compiled', -> gulp.src(compiledDir+'/*').pipe(clean())
gulp.task 'clean-dist', -> gulp.src(distDir+'/*').pipe(clean())

gulp.task 'copy-static-compiled', -> gulp.src('./static/**/*').pipe(gulp.dest(compiledDir))
gulp.task 'copy-static-dist', -> gulp.src('./static/**/*').pipe(gulp.dest(distDir))

gulp.task 'copy-images-compiled', ['copy-static-compiled'], -> gulp.src('./node_modules/hilib/images/**/*').pipe(gulp.dest(compiledDir+'/images/hilib'))
gulp.task 'copy-images-dist', ['copy-static-dist'], -> gulp.src('./node_modules/hilib/images/**/*').pipe(gulp.dest(distDir+'/images/hilib'))

gulp.task 'copy-index', -> gulp.src(compiledDir+'/index.html').pipe(gulp.dest(distDir))

gulp.task 'compile', ['clean-compiled'], ->
	gulp.start 'copy-images-compiled'
	gulp.start 'browserify'
	gulp.start 'jade'
	gulp.start 'stylus'

gulp.task 'build', ['clean-dist'], ->
	gulp.start 'copy-images-dist'
	gulp.start 'copy-index'
	gulp.start 'uglify'
	gulp.start 'minify-css'
	
gulp.task 'watch', ->
	gulp.watch [paths.jade], ['jade']
	gulp.watch [paths.stylus], ['stylus']

# gulp.task 'watchify', ->
# 	bundler = watchify
# 		entries: './src/coffee/main.cjsx'
# 		extensions: ['.coffee']

# 	# bundler.transform('coffeeify')
# 	# bundler.transform('jadeify')
# 	# bundler.transform('brfs')
# 	bundler.transform('coffee-reactify')

# 	rebundle = ->
# 		gutil.log 'Bundling'
# 		bundler.bundle()
# 			.on('error', gutil.log.bind(gutil, 'Browserify Error'))
# 			.pipe(source('main.js'))
# 			.pipe(gulp.dest('./compiled/js'))
# 			.pipe(reload())

# 	bundler.on('update', rebundle)

# 	rebundle()


createBundle = (watch=false) ->
	args =
		entries: './src/coffee/main.cjsx'
		extensions: ['.cjsx', '.coffee']
		debug: true

	bundler = if watch then watchify(args) else browserify(args)

	#  bundler.transform('coffeeify')
	bundler.transform('coffee-reactify')
	# bundler.transform('envify')

	rebundle = ->
		gutil.log('Watchify rebundling') if watch
		bundler.bundle()
			.on('error', ((err) -> gutil.log("Bundling error ::: "+err)))
			.pipe(source("main.js"))
			.pipe(gulp.dest("#{compiledDir}/js"))
			.pipe(reload({stream:true, once: true}))
			.on('error', gutil.log)

	bundler.on('update', rebundle)

	rebundle()

gulp.task 'browserify', -> createBundle false
gulp.task 'watchify', -> createBundle true

gulp.task 'default', ['server']

# gulp.task 'psi', (done) ->
# 	opts =
# 		nokey: 'true'
# 		url: 'localhost:900'
# 		strategy: 'desktop'
# 	psi opts, done
