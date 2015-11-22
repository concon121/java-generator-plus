Command = require './command'
Parser = require './parser'

module.exports =
    activate: ->
        # Register commands
        atom.commands.add 'atom-workspace', 'java-generator:generate-getters-setters', => @generateGettersAndSetters()
        atom.commands.add 'atom-workspace', 'java-generator:generate-constructor', => @generateConstructor()
        atom.commands.add 'atom-workspace', 'java-generator:generate-to-string', => @generateToString()
        atom.commands.add 'atom-workspace', 'java-generator:generate-builder', => @generateBuilder()

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
        code = ""

        if atom.config.get('java-generator.toggles.generateMethodComments')
            code += "\n\t/**\n\t* Returns value of "
            code += variable.getName()
            code += "\n\t* @return\n\t*/"

        code += "\n\tpublic "

        if variable.getIsStatic()
            code += "static "

        code += variable.getType() + " get" + variable.getCapitalizedName() + "() {\n\t\treturn "
        if atom.config.get('java-generator.toggles.appendThisToGetters') then code += "this."
        code += variable.getName() + ";\n\t}\n"

        return code

    createSetter: (variable) ->
        code = ""

        if atom.config.get('java-generator.toggles.generateMethodComments')
            code += "\n\t/**\n\t* Sets new value of "
            code += variable.getName()
            code += "\n\t* @param\n\t*/"

        code += "\n\tpublic "

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
        # Always make the getter
        code = @createGetter(variable)

        # Make the setter if it is NOT final
        if !variable.getIsFinal()
          code += @createSetter(variable)

        return code

    createToString: (data) ->
        counter = 0
        code = ""
        cmd = new Command()
        parser = new Parser()
        parser.setContent(cmd.getEditorText())
        className = parser.getClassName()

        if atom.config.get('java-generator.toggles.generateMethodComments')
            code += "\n\t/**\n\t* Create string representation of "
            code += className
            code += " for printing\n\t* @return\n\t*/"

        code += "\n\t@Override\n\tpublic String toString() {\n\t\treturn \""

        code += className
        code += " ["

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
        code = "";
        cmd = new Command()
        parser = new Parser()
        parser.setContent(cmd.getEditorText())
        className = parser.getClassName()

        code += "\n\tpublic static class Builder {"

        for variable in data
            name = variable.getName()
            type = variable.getType()
            code += "\n\t\t private static "+ type + " " + name + ";"

        for variable in data
            name = variable.getName()
            type = variable.getType()

            code += "\n\n\t\t public static Builder " + name + "("
            code += type + " " + name +  ") {"

            code += "\n\t\t\t this." + name + " = " + name + ";"
            code += "\n\t\t\t return this;"
            code += "\n\t\t}"

        code += "\n\n\t\tpublic " + className + " create() {"
        code += "\n\n\t\t}"
        code += "\n\t}\n"
        return code

    createConstructor: (data) ->
        code = ""
        cmd = new Command()
        parser = new Parser()
        parser.setContent(cmd.getEditorText())
        className = parser.getClassName()

        if atom.config.get('java-generator.toggles.generateMethodComments')
            code += "\n\t/**\n\t* Default empty "
            code += className
            code += " constructor\n\t*/"

        # First, an empty one
        code += "\n\tpublic " + className + "() {\n\t\tsuper();\n\t}\n"

        if atom.config.get('java-generator.toggles.generateMethodComments')
            code += "\n\t/**\n\t* Default "
            code += className
            code += " constructor\n\t*/"

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

        code = ""
        for variable in data
            code += @createGetter(variable)

        cmd = new Command()
        cmd.insertAtEndOfFile(code)

    generateSetters: ->
        editor = atom.workspace.getActiveTextEditor()
        unless editor.getGrammar().scopeName is 'text.java' or editor.getGrammar().scopeName is 'source.java'
            alert ('This command is meant for java files only.')
            return

        data = @parseVars(true, false)

        code = ""
        for variable in data
            code += @createSetter(variable)

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

        data = @parseVars(false, false)

        if atom.config.get('java-generator.toggles.generateGettersThenSetters')
            @generateGetters()
            @generateSetters()
        else
          code = ""
          for variable in data
            code += @createGetterAndSetter(variable)

          cmd = new Command()
          cmd.insertAtEndOfFile(code)

    config:
      toggles:
        type: 'object'
        order: 1
        properties:
          appendThisToGetters:
            title: 'Append \'this\' to Getters'
            description: 'Return satements look like `return this.param`'
            type: 'boolean'
            default: false
          generateGettersThenSetters:
            title: 'Generate Getters then Setters'
            description: 'Generates all Getters then all Setters instead of grouping them together.'
            type: 'boolean'
            default: false
          generateMethodComments:
            title: 'Generate Method Comments'
            description: 'Generate default method comments'
            type: 'boolean'
            default: true
