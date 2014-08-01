require('coffee-script/register');

gulp        = require("gulp")
browserSync = require("browser-sync")
sass        = require("gulp-sass")
coffee      = require("gulp-coffee")
prefix      = require("gulp-autoprefixer")
cp          = require("child_process")
include     = require("gulp-include")
wiredep     = require('wiredep').stream


messages =
  jekyllBuild: 
    "<span style=\"color: grey\">Running:</span> $ jekyll build"
  restartKaton: 
    "<span style=\"color: grey\">Restarting:</span> $ katon"

paths =
  source: new ->
    this.base          = "./source"
    
    # SASS Sources
    this.sass          = "#{this.base}/_scss"
    this.sassMain      = "#{this.sass}/app.scss"
    this.sassWatch     = "#{this.sass}/**/*.scss"

    # Coffeescript Sources
    this.coffee        = "#{this.base}/_coffee"
    this.coffeeMain    = "#{this.coffee}/app.coffee"
    this.coffeeWatch   = "#{this.coffee}/**/*.coffee"

    # Layout Source
    this.layouts       = "#{this.base}/_layouts"
    this.layoutDefault = "#{this.layouts}/default.html"

    # Bower
    this.components    = "./components"
    this.bower         = "./bower.json"

    # All other files will trigger a browsersync reload
    this.otherWatch    = ["#{this.base}/**/*", "!#{this.sass}/*.scss", "!#{this.coffee}/*.coffee", "!#{this.base}/css/**/*", "!#{this.base}/js/**/*"]
    
    # Special files to watch that will kill the task and restart it when they are changed
    this.killWatch     = ["Gemfile", "Gemfile.lock", "gulpfile.coffee", "gulpfile.js", "package.json"]
    
    return this

  build: new ->
    this.base          = "./build"
    this.css           = "#{this.base}/css"
    this.js            = "#{this.base}/js"


###
Build the Jekyll Site
###
gulp.task "jekyll-build", (done) ->
  browserSync.notify messages.jekyllBuild
  cp.spawn("bundle", ["exec", "jekyll", "build"],
    stdio: "inherit"
  ).on "close", done


###
Rebuild Jekyll & do page reload
###
gulp.task "jekyll-rebuild", ["jekyll-build"], ->
  browserSync.reload()
  return

###
Restart Katon
###
gulp.task "kill-task", (done) ->
  browserSync.notify messages.restartKaton
  cp.spawn("katon", ["stop"],
    stdio: "inherit"
  ).on "close", ->
    cp.spawn("katon", ["start"],
      stdio: "inherit"
    ).on "close", done


###
Wait for jekyll-build, then launch the Server
###
gulp.task "browser-sync", [
  "bower"
  "sass"
  "coffee"
  "jekyll-build"
], ->
  browserSync 
    server:
      baseDir: [paths.build.base, '.']
    port: process.env.PORT || 3000
    host: '0.0.0.0'
    open: false

  return


###
Compile files from _scss into both build/css (for live injecting) and source/css (for future jekyll builds)
###
gulp.task "sass", ->
  gulp.src(paths.source.sassMain)
    .pipe(include())
    .pipe sass
      onError: browserSync.notify
      includePaths: ['source/_scss', './components/bootstrap-sass-official/assets/stylesheets/bootstrap']
    .pipe prefix [
        "last 15 versions"
        "> 1%"
        "ie 8"
        "ie 7"
      ] , cascade: true
    .pipe(gulp.dest(paths.build.css))
    .pipe(browserSync.reload(stream: true))
    .pipe gulp.dest(paths.source.base + "/css")
  return

###
Compile files from _coffee into both build/js (for live injecting) and source/js (for future jekyll builds)
###
gulp.task "coffee", ->
  gulp.src(paths.source.coffeeMain)
    .pipe(include())
    .pipe(coffee(onError: browserSync.notify))
    .pipe(gulp.dest(paths.build.js))
    .pipe(browserSync.reload(stream: true))
    .pipe(gulp.dest(paths.source.base + "/js"))
  return


###
Inject files from Bower.json into our layout file
###
gulp.task 'bower', ->
  gulp.src(paths.source.layoutDefault)
    .pipe wiredep()
    .pipe gulp.dest(paths.source.layouts)


###
Watch scss files for changes & recompile
Watch html/md files, run jekyll & reload BrowserSync
###
gulp.task "watch", ->
  gulp.watch paths.source.sassWatch, ["sass"]
  gulp.watch paths.source.coffeeWatch, ["coffee"]
  gulp.watch paths.source.bower, ["bower"]
  gulp.watch paths.source.otherWatch, ["jekyll-rebuild"]
#  gulp.watch paths.source.killWatch, ["kill-task"]
    
  return


###
Default task, running just `gulp` will compile the sass,
compile the jekyll site, launch BrowserSync & watch files.
###
gulp.task "default", [
  "browser-sync"
  "watch"
]