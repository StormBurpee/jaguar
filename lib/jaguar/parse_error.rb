module Jaguar

  class ParseError < Racc::ParseError
    TOKEN_MAP = {
      'INDENT' => 'indent',
      'DEDENT' => 'dedent',
      "\n"     => 'newline'
    }

    def initialize(token_id, value, stack=nil, message=nil)
      @token_id, @value, @stack, @message = token_id, value, stack, message
    end

    def message
      line = @value.respond_to?(:line) ? @value.line : "END"
      line_part = "line #{line}:"
      id_part = @token_id != @value.to_s ? " unexpected #{@token_id.to_s.downcase}" : ""
      val_part = @message || "for #{TOKEN_MAP[@value.to_s] || "'#{@value}'"}"
      "#{line_part} syntax error, #{val_part}#{id_part}"
    end
    alias_method :inspect, :message

  end

end
