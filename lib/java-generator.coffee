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
        code = "\n\tpublic "

        if variable.getIsStatic()
            code += "static "

        code += variable.getType() + " get" + variable.getCapitalizedName() + "() {\n\t\treturn " + variable.getName() + ";\n\t}\n"

        return code

    createSetter: (variable) ->
        code = "\n\tpublic "

        if variable.getIsStatic()
            code += "static "

        code += "void set" + variable.getCapitalizedName() + "(" + variable.getType() + " " + variable.getName() + ") {\n\t\t"

        if variable.getIsStatic()
            cmd = new Command()
            parser = new Parser()
            parser.setContent(cmd.getEditorText())
            code += parser.getClassName() + "."
        else
            code += "this."

        code += variable.getName() + " = " + variable.getName() + ";\n\t}\n"

        return code

    createToString: (data) ->
        counter = 0
        code = "\n\t@Override\n\tpublic String toString() {\n\t\treturn \""

        cmd = new Command()
        parser = new Parser()
        parser.setContent(cmd.getEditorText())
        code += parser.getClassName() + " ["

        counter = 0;
        size = data.length
        for variable in data
            if ! variable.getIsStatic()
                name = variable.getName()
                code += name + "=\" + " + name + " + \""

                if counter + 1 < size
                    code += ", "
                else
                    code += "]\";\n\t}\n"

            counter++

        if /, $/.test(code)
            code = code.substring(0, code.length - 2) + "]\";\n\t}\n"

        return code

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
        editor = atom.workspace.getActiveTextEditor()
        unless editor.getGrammar().scopeName is 'text.java' or editor.getGrammar().scopeName is 'source.java'
            alert ('This command is meant for java files only.')
            return

        data = @parseVars(false)

        code = @createToString(data)
        cmd = new Command()
        cmd.insertAtEndOfFile(code)
