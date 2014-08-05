gulp = require 'gulp'
gutil = require 'gulp-util'
connect = require 'gulp-connect'
jade = require 'gulp-jade'
concat = require 'gulp-concat'
clean = require 'gulp-clean'
stylus = require 'gulp-stylus'
browserify = require 'gulp-browserify'
rename = require 'gulp-rename'
connectRewrite = require './connect-rewrite'
cache = require 'gulp-cached'
plumber = require 'gulp-plumber'
uglify = require 'gulp-uglify'
minifyCss = require 'gulp-minify-css'
source = require 'vinyl-source-stream'
watchify = require 'watchify'
reactify = require 'reactify'
brfs = require 'brfs'
bodyParser = require 'body-parser'
psi = require 'psi'
# console.log bodyParser()

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

gulp.task 'connect', connect.server
	root: compiledDir,
	port: 9000,
	livereload: true
	middleware: (connect, options) -> [bodyParser(), connectRewrite(connect, options)]

gulp.task 'connect-dist', connect.server
	root: distDir,
	port: 9002,
	middleware: connectRewrite

gulp.task 'jade', ->
	gulp.src(paths.jade)
		.pipe(plumber())
		.pipe(jade())
		.pipe(gulp.dest(compiledDir))
		.pipe(connect.reload())

gulp.task 'browserify', ->
	gulp.src('./src/coffee/main.cjsx', read: false)
		.pipe(plumber())
		.pipe(cache('browserify'))
		.pipe(browserify(
			transform: ['coffee-reactify']
			# extensions: ['.coffee', '.jade']
		))
		.pipe(rename(extname:'.js'))
		.pipe(gulp.dest(compiledDir+'/js'))
		.pipe(connect.reload())

gulp.task 'stylus', ->
	gulp.src(paths.stylus)
		.pipe(plumber())
		.pipe(stylus(
			use: ['nib']
		))
		.pipe(concat('main.css'))
		.pipe(gulp.dest(compiledDir+'/css'))
		.pipe(connect.reload())

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

gulp.task 'watchify', ->
	bundler = watchify
		entries: './src/coffee/main.cjsx'
		extensions: ['.coffee']

	# bundler.transform('coffeeify')
	# bundler.transform('jadeify')
	# bundler.transform('brfs')
	bundler.transform('coffee-reactify')

	rebundle = ->
		gutil.log 'Bundling'
		bundler.bundle()
			.pipe(source('main.js'))
			.pipe(gulp.dest('./compiled/js'))
			.pipe(connect.reload())

	bundler.on('update', rebundle)

	rebundle()

gulp.task 'default', ['connect', 'watch', 'watchify']

gulp.task 'psi', (done) ->
	opts =
		nokey: 'true'
		url: 'localhost:900'
		strategy: 'desktop'
	psi opts, done
