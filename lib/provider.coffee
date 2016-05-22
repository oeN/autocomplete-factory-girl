fs = require 'fs'

module.exports =
  selector: '.source.ruby.rspec'
  disableForSelector: 'source.ruby .comment'
  filterSuggestions: true

  load: ->
    @loadCompletions()
    for editor in atom.workspace.getTextEditors()
      if editor.getPath().includes @factoryDirectory()
        editor.onDidSave =>
          @loadCompletions()

  getSuggestions: (request) ->
    {prefix} = request
    completions = []
    for factory in @allCompletions when not prefix or firstCharsEqual(factory, prefix)
      completions.push(@buildCompletion(factory))
    completions

  scanFactories: () ->
    try
      results = []
      factoryPattern = /factory :(\w+)/g
      for factory_file in fs.readdirSync("#{@rootDirectory()}#{@factoryDirectory()}")
        data = fs.readFileSync "#{@rootDirectory()}#{@factoryDirectory()}/#{factory_file}", 'utf8'
        while (matches = factoryPattern.exec(data)) != null
          results.push matches[1]
      results
    catch e

  rootDirectory: ->
    atom.project.rootDirectories[0].path;

  factoryDirectory: ->
    "/spec/factories"

  buildCompletion: (factory) ->
    text: "#{factory}"
    rightLabel: 'FactoryGirl'

  loadCompletions: ->
    @allCompletions = @scanFactories()

firstCharsEqual = (str1, str2) ->
  str1[0].toLowerCase() is str2[0].toLowerCase()
