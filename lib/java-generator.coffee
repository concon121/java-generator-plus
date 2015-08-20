Command = require './command'
Parser = require './parser'

module.exports =
    activate: ->
        # Register commands
        atom.commands.add 'atom-workspace', 'java-generator:generate-getters', => @generateGetters()
        atom.commands.add 'atom-workspace', 'java-generator:generate-setters', => @generateSetters()
        atom.commands.add 'atom-workspace', 'java-generator:generate-constructor', => @generateConstructor()
        atom.commands.add 'atom-workspace', 'java-generator:generate-to-string', => @generateToString()

    parseVars: (removeFinalVars) ->
        cmd = new Command()
        parser = new Parser()

        parser.setContent(cmd.getEditorText())

        if removeFinalVars
            return parser.getNonFinalVars()
        else
            return parser.getAllVars()

    createGetter: (variable) ->
        return "\n\tpublic " + variable.getType() + " get" + variable.getCapitalizedName() + "() {\n\t\treturn this." + variable.getName() + ";\n\t}\n"

    createSetter: (variable) ->
        return "\n\tpublic void set" + variable.getCapitalizedName() + "(" + variable.getType() + " " + variable.getName() + ") {\n\t\tthis." + variable.getName() + " = " + variable.getName() + ";\n\t}\n"

    generateGetters: ->
        editor = atom.workspace.getActiveTextEditor()
        unless editor.getGrammar().scopeName is 'text.java' or editor.getGrammar().scopeName is 'source.java'
            alert ('This command is meant for java files only.')
            return

        data = @parseVars(false)

        for variable in data
            code = @createGetter(variable)
            cmd = new Command()
            cmd.insertAtEndOfFile(code)

    generateSetters: ->
        editor = atom.workspace.getActiveTextEditor()
        unless editor.getGrammar().scopeName is 'text.java' or editor.getGrammar().scopeName is 'source.java'
            alert ('This command is meant for java files only.')
            return

        data = @parseVars(true)

        for variable in data
            code = @createSetter(variable)
            cmd = new Command()
            cmd.insertAtEndOfFile(code)

    generateConstructor: ->
        editor = atom.workspace.getActivePaneItem()
        editor.insertText('\nA Constructor Goes Here!\n')

    generateToString: ->
        editor = atom.workspace.getActivePaneItem()
        editor.insertText('\nA toString Goes Here!\n')
