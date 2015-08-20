Command = require './command'
Parser = require './parser'

module.exports =
    activate: ->
        # Register commands
        atom.commands.add 'atom-workspace', 'java-generator:generate-getters', => @generateGetters()
        atom.commands.add 'atom-workspace', 'java-generator:generate-setters', => @generateSetters()
        atom.commands.add 'atom-workspace', 'java-generator:generate-constructor', => @generateConstructor()
        atom.commands.add 'atom-workspace', 'java-generator:generate-to-string', => @generateToString()

    parseVars: ->
        cmd = new Command()
        parser = new Parser()

        parser.setContent(cmd.getEditorText())

        return parser.getVars()

    generateGetters: ->
        editor = atom.workspace.getActiveTextEditor()
        unless editor.getGrammar().scopeName is 'text.java' or editor.getGrammar().scopeName is 'source.java'
            alert ('This command is meant for java files only.')
            return

        data = @parseVars()

    generateSetters: ->
        editor = atom.workspace.getActivePaneItem()
        editor.insertText('\nA Setter Goes Here!\n')

    generateConstructor: ->
        editor = atom.workspace.getActivePaneItem()
        editor.insertText('\nA Constructor Goes Here!\n')

    generateToString: ->
        editor = atom.workspace.getActivePaneItem()
        editor.insertText('\nA toString Goes Here!\n')
