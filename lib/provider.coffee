fs = require 'fs'

module.exports =
  selector: '.source.ruby'
  disableForSelector: 'source.ruby .comment'

  load: () ->
    @completions = @scanFactories()

  getSuggestions: (request) ->
    {prefix} = request
    completions = []
    for factory in @completions when not prefix or firstCharsEqual(factory, prefix)
      completions.push(@buildCompletion(factory))
    completions

  scanFactories: () ->
    results = []
    factoryPattern = /factory :(\w+)/g
    for factory_file in fs.readdirSync("#{@rootDirectory()}/spec/factories")
      data = fs.readFileSync "#{@rootDirectory()}/spec/factories/#{factory_file}", 'utf8'
      while (matches = factoryPattern.exec(data)) != null
        results.push matches[1]
    results

  rootDirectory: ->
    atom.project.rootDirectories[0].path;

  buildCompletion: (factory) ->
    text: ":#{factory}"
    rightLabel: 'FactoryGirl'

firstCharsEqual = (str1, str2) ->
  str1[0].toLowerCase() is str2[0].toLowerCase()
