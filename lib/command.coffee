module.exports =
class Command

    insertAtEndOfFile: (text) ->
        # Find last '}' and insert text just before it
        content = @getEditorText()
        last = content.lastIndexOf('}')
        editor = atom.workspace.getActiveTextEditor()

        editor.setText ([content.slice(0, last), text, content.slice(last)].join(''))

    getEditorText: ->
        # Get editor text and return it
        editor = atom.workspace.getActiveTextEditor()
        return editor.getText()
