{CompositeDisposable} = require 'atom'

module.exports =
    activate: ->
        # Register commands
        atom.commands.add 'atom-workspace', 'java-generator:generate-getters', => @generateGetters()
        atom.commands.add 'atom-workspace', 'java-generator:generate-setters', => @generateSetters()
        atom.commands.add 'atom-workspace', 'java-generator:generate-constructor', => @generateConstructor()
        atom.commands.add 'atom-workspace', 'java-generator:generate-to-string', => @generateToString()

    generateGetters: ->
        editor = atom.workspace.getActivePaneItem()
        editor.insertText('\nA Getter Goes Here!\n')

    generateSetters: ->
        editor = atom.workspace.getActivePaneItem()
        editor.insertText('\nA Setter Goes Here!\n')

    generateConstructor: ->
        editor = atom.workspace.getActivePaneItem()
        editor.insertText('\nA Constructor Goes Here!\n')

    generateToString: ->
        editor = atom.workspace.getActivePaneItem()
        editor.insertText('\nA toString Goes Here!\n')
