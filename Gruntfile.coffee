#Example: https://github.com/fczbkk/Savedeo-Extension/blob/master/Gruntfile.coffee
module.exports = (grunt)->
  firefoxStableVersion = "1.16"
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    "mozilla-addon-sdk":
      'stable':
        options:
          revision: firefoxStableVersion

    "mozilla-cfx-xpi":
      'stable':
        options:
          "mozilla-addon-sdk": "stable"
          extension_dir: "ff_extension"
          dist_dir: "tmp/dist-stable"


    "mozilla-cfx":
      'run_stable':
        options:
          "mozilla-addon-sdk": 'stable'
          extension_dir: "ff_extension"
          command: "run"
  grunt.loadNpmTasks 'grunt-mozilla-addon-sdk'
