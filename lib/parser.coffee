Variable = require './variable'

module.exports =
class Parser
    varRegexArray: /(public|private|protected)\s*(static)?\s*(final)?\s*(volatile|transient)?\s*([a-zA-Z0-9_$\<\>]+)\s*([a-zA-Z0-9_$]+)(\(.*\))?/g
    varRegex: /(public|private|protected)\s*(static)?\s*(final)?\s*(volatile|transient)?\s*([a-zA-Z0-9_$\<\>]+)\s*([a-zA-Z0-9_$]+)(\(.*\))?/
    methodRegex: /\(([a-zA-Z0-9_$\<\>\.\,\s]+)?\)/
    classNameRegex: /(?:class)\s+([a-zA-Z0-9_$]+)/
    classRegex: /class/
    finalRegex: /^final$/
    staticRegex: /^static$/
    content: ''

    setContent: (@content) ->

    getContent: ->
        return @content

    getVars: ->
        # Find lines with variables
        varLines = @content.match(@varRegexArray)

        # Check if any were found
        if ! varLines
            alert ('No variables were found.')
            return {}

        variables = []
        for line in varLines
            # Skip method and class declarations
            if ! @methodRegex.test(line) && ! @classRegex.test(line)
                group = @varRegex.exec(line)
                if group != null
                    isStatic = false
                    isFinal = false

                    # Check if static
                    if group[2] != null && @staticRegex.test(group[2])
                        isStatic = true

                    # Check if final
                    if group[3] != null && @finalRegex.test(group[3])
                        isFinal = true

                    # Create variable and store it
                    variable = new Variable(group[6], group[5], isStatic, isFinal)
                    variables.push (variable)

        return variables

    getClassName: ->
        # Find class name and return it
        match = @content.match(@classNameRegex)
        return match[1]
