Command = require './command'
Parser = require './parser'

module.exports =
    activate: ->
        # Register commands
        atom.commands.add 'atom-workspace', 'java-generator:generate-getters', => @generateGetters()
        atom.commands.add 'atom-workspace', 'java-generator:generate-setters', => @generateSetters()
        atom.commands.add 'atom-workspace', 'java-generator:generate-constructor', => @generateConstructor()
        atom.commands.add 'atom-workspace', 'java-generator:generate-to-string', => @generateToString()
        atom.commands.add 'atom-workspace', 'java-generator:generate-builder', => @generateBuilder()
        atom.commands.add 'atom-workspace', 'java-generator:generate-getters-setters', => @generateGettersAndSetters()

    parseVars: (removeFinalVars, removeStaticVars) ->
        cmd = new Command()
        parser = new Parser()

        parser.setContent(cmd.getEditorText())

        data = parser.getVars()

        # Remove Final Variables, iterate in reverse so we don't skip records on splice
        if removeFinalVars
            i = data.length - 1
            while i >= 0
                variable = data[i]
                if variable.getIsFinal()
                    data.splice(i, 1)
                i--

        # Remove Static Variables, iterate in reverse so we don't skip records on splice
        if removeStaticVars
            i = data.length - 1
            while i >= 0
                variable = data[i]
                if variable.getIsStatic()
                    data.splice(i, 1)
                i--


        return data

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

    createGetterAndSetter: (variable) ->
        code  = @createGetter(variable)
        code += @createSetter(variable)

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
            name = variable.getName()
            code += name + "=\" + " + name + " + \""

            if counter + 1 < size
                code += ", "
            else
                code += "]\";\n\t}\n"

            counter++

        return code

    createBuilder: (data) ->
        cmd = new Command()
        parser = new Parser()
        parser.setContent(cmd.getEditorText())
        className = parser.getClassName()

        code = "\n\tpublic static class Builder {"

        for variable in data
            name = variable.getName()
            type = variable.getType()
            code += "\n\t\t private static "+ type + " " + name + ";"

        for variable in data
            name = variable.getName()
            type = variable.getType()

            code += "\n\n\t\t public static Builder " + name + "("
            code += type + " " + name +  "){"

            code += "\n\t\t\t this." + name + " = " + name + ";"
            code += "\n\t\t\t return this;"
            code += "\n\t\t}"

        code += "\n\n\t\tpublic " + className + " create(){"
        code += "\n\n\t\t}"
        code += "\n\t}\n"
        return code

    createConstructor: (data) ->
        cmd = new Command()
        parser = new Parser()
        parser.setContent(cmd.getEditorText())
        className = parser.getClassName()

        # First, an empty one
        code = "\n\tpublic " + className + "() {\n\t\tsuper();\n\t}\n"

        # Second, one with all variables
        code += "\n\tpublic " + className + "("

        # add params
        counter = 0
        size = data.length
        for variable in data
            code += variable.getType() + " " + variable.getName()
            if counter + 1 < size
                code += ", "
            else
                code += ")"

            counter++

        code += " {\n\t\tsuper();"

        # Add assignments
        for variable in data
            code += "\n\t\tthis." + variable.getName() + " = " + variable.getName() + ";"

        code += "\n\t}\n"

        return code

    generateGetters: ->
        editor = atom.workspace.getActiveTextEditor()
        unless editor.getGrammar().scopeName is 'text.java' or editor.getGrammar().scopeName is 'source.java'
            alert ('This command is meant for java files only.')
            return

        data = @parseVars(false, false)

        for variable in data
            code = @createGetter(variable)
            cmd = new Command()
            cmd.insertAtEndOfFile(code)

    generateSetters: ->
        editor = atom.workspace.getActiveTextEditor()
        unless editor.getGrammar().scopeName is 'text.java' or editor.getGrammar().scopeName is 'source.java'
            alert ('This command is meant for java files only.')
            return

        data = @parseVars(true, false)

        for variable in data
            code = @createSetter(variable)
            cmd = new Command()
            cmd.insertAtEndOfFile(code)

    generateToString: ->
        editor = atom.workspace.getActiveTextEditor()
        unless editor.getGrammar().scopeName is 'text.java' or editor.getGrammar().scopeName is 'source.java'
            alert ('This command is meant for java files only.')
            return

        data = @parseVars(false, true)

        code = @createToString(data)
        cmd = new Command()
        cmd.insertAtEndOfFile(code)

    generateConstructor: ->
        editor = atom.workspace.getActiveTextEditor()
        unless editor.getGrammar().scopeName is 'text.java' or editor.getGrammar().scopeName is 'source.java'
            alert ('This command is meant for java files only.')
            return

        data = @parseVars(true, true)

        code = @createConstructor(data)
        cmd = new Command()
        cmd.insertAtEndOfFile(code)

    generateBuilder: ->
        editor = atom.workspace.getActiveTextEditor()
        unless editor.getGrammar().scopeName is 'text.java' or editor.getGrammar().scopeName is 'source.java'
            alert ('This command is meant for java files only.')
            return

        data = @parseVars(true, true)

        code = @createBuilder(data)
        cmd = new Command()
        cmd.insertAtEndOfFile(code)

    generateGettersAndSetters: ->
        editor = atom.workspace.getActiveTextEditor()
        unless editor.getGrammar().scopeName is 'text.java' or editor.getGrammar().scopeName is 'source.java'
            alert ('This command is meant for java files only.')
            return

        data = @parseVars(true, true)

        for variable in data
            code = @createGetterAndSetter(variable)
            cmd = new Command()
            cmd.insertAtEndOfFile(code)
