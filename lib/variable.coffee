module.exports =
class Variable
    name: ' '
    capitalizedName: ' '
    type: ' '

    #TODO - static/final/transient/volatile
    constructor: (name, type) ->
        @name = name
        @capitalizedName = name.charAt(0).toUpperCase() + name.substring(1, name.length)
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
