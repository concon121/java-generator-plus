module.exports =
class Parser
    content : ''

    setContent: (@content) ->

    getContent: ->
        return @content

    getVars: ->
        varLines = @getContent().match(/\s*(public|private|protected)\s*(static)?\s*(final)?/g)
        alert ("varLines: " + varLines.toString())

        if ! varLines
            alert ('No variables were found.')
            return {}

        lines = []
        for line in varLines
            #variables.push (@processVarLine(line))
            lines.push (line)

        return lines
