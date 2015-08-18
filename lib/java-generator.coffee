JavaGeneratorView = require './java-generator-view'
{CompositeDisposable} = require 'atom'

module.exports = JavaGenerator =
  javaGeneratorView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @javaGeneratorView = new JavaGeneratorView(state.javaGeneratorViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @javaGeneratorView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add atom.commands.add 'atom-workspace', 'java-generator:generate-getters': => @generateGetters()
    @subscriptions.add atom.commands.add 'atom-workspace', 'java-generator:generate-setters': => @generateSetters()
    @subscriptions.add atom.commands.add 'atom-workspace', 'java-generator:generate-constructor': => @generateConstructor()
    @subscriptions.add atom.commands.add 'atom-workspace', 'java-generator:generate-to-string': => @generateToString()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @javaGeneratorView.destroy()

  serialize: ->
    javaGeneratorViewState: @javaGeneratorView.serialize()
