module.exports =
class Command

    insertAtEndOfFile: (text) ->
        content = @getEditorText()
        last = content.lastIndexOf('}')
        editor = atom.workspace.getActiveTextEditor()

        editor.setText ([content.slice(0, last), text, content.slice(last)].join(''))

    getEditorText: ->
        editor = atom.workspace.getActiveTextEditor()

        return editor.getText()
