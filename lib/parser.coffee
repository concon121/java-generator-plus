Variable = require './variable'

module.exports =
class Parser
    varRegexArray: /(public|private|protected)\s*(static)?\s*(final)?\s*(volatile|transient)?\s*([a-zA-Z0-9_$\<\>]+)\s*([a-zA-Z0-9_$]+)(\(.*\))?/g
    varRegex: /(public|private|protected)\s*(static)?\s*(final)?\s*(volatile|transient)?\s*([a-zA-Z0-9_$\<\>]+)\s*([a-zA-Z0-9_$]+)(\(.*\))?/
    methodRegex: /\(([a-zA-Z0-9_$\<\>\.\s]+)?\)/
    classRegex: /class/
    content: ''

    setContent: (@content) ->

    getContent: ->
        return @content

    getVars: ->
        varLines = @content.match(@varRegexArray)

        if ! varLines
            alert ('No variables were found.')
            return {}

        variables = []
        for line in varLines
            # Skip method and class declarations
            if ! @methodRegex.test(line) && ! @classRegex.test(line)
                group = @varRegex.exec(line)
                if group != null
                  variable = new Variable(group[6], group[5])
                  variables.push (variable)

        alert ("variables: " + variables.toString())
        return variables
