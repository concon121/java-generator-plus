module.exports =
class Variable
    name: ' '
    capitalizedName: ' '
    type: ' '
    isStatic: false
    isFinal: false

    constructor: (name, type, isStatic, isFinal) ->
        @name = name
        @capitalizedName = name.charAt(0).toUpperCase() + name.substring(1, name.length)
        @type = type
        @isStatic = isStatic
        @isFinal = isFinal

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

    getIsFinal: ->
        return @isFinal

    setIsFinal: (value) ->
        @isFinal = value

    getCapitalizedName: ->
        return @capitalizedName

    toString: ->
        return "Name: " + @name + " - " + "Type: " + @type + " - " + "isStatic: " + @isStatic + " - " + "isFinal: " + @isFinal
