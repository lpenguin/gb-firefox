#Example: https://github.com/fczbkk/Savedeo-Extension/blob/master/Gruntfile.coffee
module.exports = (grunt)->
  firefoxStableVersion = "1.16"
  firefoxExtentionDir = 'firefox'
  firefoxExtentionDistDir = "#{firefoxExtentionDir}/build"
  grunt.initConfig
    debug: true
    pkg: grunt.file.readJSON('package.json')
    "mozilla-addon-sdk":
      'stable':
        options:
          revision: firefoxStableVersion

    "mozilla-cfx-xpi":
      'stable':
        options:
          "mozilla-addon-sdk": "stable"
          extension_dir: firefoxExtentionDir
          dist_dir: firefoxExtentionDistDir


    "mozilla-cfx":
      'run_stable':
        options:
          "mozilla-addon-sdk": 'stable'
          extension_dir: firefoxExtentionDir
          command: "run"

    coffee:
      default:
        options:
          bare: true
        files:
          # Firefox
          'firefox/lib/main.js' : [
            'firefox/coffee/main.coffee'
          ]
          'firefox/data/js/panel.js': [
            'firefox/coffee/data-src/panel.coffee'
          ]
    watch:
      default:
        options:
          atStart: true
        files: ['firefox/coffee/*/*.coffee']
        tasks: ['dev']
    bowercopy:
      firefox:
        options:
          destPrefix: 'firefox/data/bower/'
        files:
          'css/': 'pure/pure.css'

  grunt.loadNpmTasks 'grunt-mozilla-addon-sdk'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks('grunt-bowercopy')

  grunt.registerTask 'default', ['watch:default']
  grunt.registerTask 'dev', [
    'coffee:default'
  ]
