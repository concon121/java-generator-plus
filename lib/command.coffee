module.exports =
class Command

    insertAtEndOfFile: (text) ->
        content = @getEditorContents()
        last = content.lastIndexOf('}')
        editor = atom.workspace.getActiveTextEditor()

        editor.setText ([content.slice(0, last), "\n" + text, content.slice(last)].join(''))

    getEditorText: ->
        editor = atom.workspace.getActiveTextEditor()

        return editor.getText()
