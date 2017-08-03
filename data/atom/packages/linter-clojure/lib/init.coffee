module.exports =
  config:
    javaExecutablePath:
      type: 'string'
      default: 'java'
    clojureExecutablePath:
      type: 'string'
      default: 'clojure-x.x.x.jar'

  activate: ->
    require('atom-package-deps').install()

  provideLinter: ->
    helpers = require('atom-linter')
    regex = 'RuntimeException:(?<message>.*), compiling:(.*):(?<line>\\d+):(?<col>\\d+)'
    provider =
      grammarScopes: ['source.clojure', 'source.clojurescript']
      scope: 'file'
      lintOnFly: true
      lint: (textEditor) =>
        filePath = textEditor.getPath()
        command = atom.config.get('linter-clojure.javaExecutablePath') or 'java'
        parameters = [
          '-jar',
          atom.config.get('linter-clojure.clojureExecutablePath'),
          '-i',
          filePath
        ]

        return helpers.exec(command, parameters, {stream: 'stderr'}).then (output) ->
          errors = for message in helpers.parse(output, regex, {filePath: filePath})
            message.type = 'error'
            message

          return errors
