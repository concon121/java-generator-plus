module.exports =
class Variable
    name: ' '
    capitalizedName: ' '
    type: ' '
    isStatic: false

    #TODO - static/final/transient/volatile
    constructor: (name, type, isStatic) ->
        @name = name
        @capitalizedName = name.charAt(0).toUpperCase() + name.substring(1, name.length)
        @type = type
        @isStatic = isStatic

    getName: ->
        return @name

    setName: (value) ->
        @name = value

    getType: ->
        return @type

    setType: (value) ->
        @type = value

    getIsStatic: ->
        return @isStatic

    setIsStatic: (value) ->
        @isStatic = value

    getCapitalizedName: ->
        return @capitalizedName

    toString: ->
        return "Name: " + @name + " - " + "Type: " + @type + " - " + "isStatic: " + @isStatic
