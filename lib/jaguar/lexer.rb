module Jaguar
  class Lexer
    KEYWORDS = ["def", "class", "if", "true", "false", "null"]

    def tokenize(code)
      code.chomp!
      tokens = []

      current_indent = 0
      indent_stack = []

      i = 0
      while i < code.size
        chunk = code[i..-1]

        # Match for identifier
        if identifier = chunk[/\A([a-z]\w*)/, 1]
          if KEYWORDS.include?(identifier)
            tokens << [identifier.upcase.to_sym, identifier]
          else
            tokens << [:IDENTIFIER, identifier]
          end
          i += identifier.size
        # Matches class names and constants, starts with a capital letter.
        elsif constant = chunk[/\A([A-Z]\w*)/, 1]
          tokens << [:CONSTANT, constant]
          i += constant.size
        # Matches for numbers
        elsif number = chunk[/\A([0-9]+)/, 1]
          tokens << [:NUMBER, number.to_i]
          i += number.size
        # Matches for strings, currently only supports '""'
        elsif string = chunk[/\A"([^"]*)"/, 1]
          tokens << [:STRING, string]
          i += string.size + 2 # Plus 2, because of the quotes.
        # Matches for indentations <newline> <spaces>
        # TODO: Change the : having to be on the end.
        elsif indent = chunk[/\A\:\n( +)/m, 1]
          if indent.size <= current_indent
            raise "Bad indent level, got #{indent.size} indents, expected > #{current_indent} indents"
          end

          current_indent = indent.size
          indent_stack.push(current_indent)
          tokens << [:INDENT, indent.size]
          i += indent.size + 2

        # matches for staying in same block, or closing block if indent gone
        elsif indent = chunk[/\A\n( *)/m, 1]
          if indent.size == current_indent
            tokens << [:NEWLINE, "\n"]
          elsif indent.size < current_indent
            while indent.size < current_indent # closes all blocks that are less than indent size
              indent_stack.pop
              current_indent = indent_stack.first || 0
              tokens << [:DEDENT, indent.size]
            end
            tokens << [:NEWLINE, "\n"]
          else
            raise "Missing ':' after raising indentation level." # TODO: fix this when you remove ':'
          end
          i += indent.size + 1
        # matches for long operators
        elsif operator = chunk[/\A(\|\||&&|==|!=|<=|>=)/, 1]
          tokens << [operator, operator]
          i += operator.size
        # matches for whitespace, ignores whitespaces
        elsif chunk.match(/\A /)
          i += 1
        # treat all other single characters as a token
        else
          value = chunk[0,1]
          tokens << [value, value]
          i += 1
        end
      end

      # close remaining open indents
      while indent = indent_stack.pop
        tokens << [:DEDENT, indent_stack.first || 0]
      end

      tokens
    end
  end
end
