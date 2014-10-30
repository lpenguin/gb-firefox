#Example: https://github.com/fczbkk/Savedeo-Extension/blob/master/Gruntfile.coffee
module.exports = (grunt)->
  firefoxStableVersion = "1.17"
  firefoxExtentionDir = 'firefox/package'
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
          'firefox/package/lib/main.js' : [
            'firefox/src/coffee/main.coffee'
          ]
          'firefox/package/lib/port.js' : [
            'firefox/src/coffee/port.coffee'
          ]
          'firefox/package/data/js/panel.js': [
            'firefox/src/coffee/panel.coffee'
          ]
          'firefox/package/lib/api.js' : [
            'firefox/src/coffee/api.coffee'
          ]
          'firefox/package/data/js/port.js': [
            'firefox/src/coffee/port.coffee'
          ]
          'firefox/package/lib/models.js': [
            'firefox/src/coffee/models.coffee'
          ]
    watch:
      default:
        options:
          atStart: true
        files: ['firefox/src/coffee/*.coffee']
        tasks: ['dev']

    copy:
      firefox:
        files:[
          { src: 'firefox/src/package.json', dest: 'firefox/package/', filter: 'isFile', flatten: true, expand: true }
          { src: 'firefox/src/js/*', dest: 'firefox/package/lib/', filter: 'isFile', flatten: true, expand: true}
          { src: 'firefox/src/layout/*', dest: 'firefox/package/data/', filter: 'isFile', flatten: true, expand: true}
          { src: 'firefox/src/css/*', dest: 'firefox/package/data/css/',  filter: 'isFile', flatten: true, expand: true}
          { src: 'firefox/src/images/*', dest: 'firefox/package/data/icons/', filter: 'isFile', flatten: true, expand: true}
          { src: 'firefox/src/package.json', dest: 'firefox/package/', filter: 'isFile', expand: true, flatten: true}
        ]

    bowercopy:
      firefox:
        options:
          destPrefix: 'firefox/package/data/'
        files:
          'css/': ['bootstrap/dist/css/bootstrap.min.css', 'selectize/dist/css/selectize.css']
          'js/': ['jquery/dist/jquery.js', 'selectize/dist/js/standalone/selectize.js']

  grunt.loadNpmTasks 'grunt-mozilla-addon-sdk'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-bowercopy'

  grunt.registerTask 'firefox', [
    'coffee:default'
    'copy:firefox'
    'bowercopy:firefox'
    'mozilla-cfx'
  ]

  grunt.registerTask 'default', ['watch:default']
  grunt.registerTask 'dev', [
    'coffee:default'
  ]
