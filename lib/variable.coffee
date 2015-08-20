module.exports =
class Variable
    name: ' '
    capitalizedName: ' '
    type: ' '

    #TODO - static/final/transient/volatile
    constructor: (name, type) ->
        @name = name
        @capitalizedName = name
        @capitalizedName.charAt(0).toUpperCase()
        @type = type

    getName: ->
        return @name

    setName: (value) ->
        @name = value

    getType: ->
        return @type

    setType: (value) ->
        @type = value

    getCapitalizedName: ->
        return @capitalizedName

    toString: ->
        return "Name: " + @name + " - " + "Type: " + @type
