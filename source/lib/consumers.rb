module Consumers
  def consume_whitespace
    consume while !eof? && /\s|\t/ =~ @symbol
  end
  
  def consume_string
    if match = /"((\\"|[^"])*)"/.match(@input[@position..-1])
      @position = @position + match.to_s.length + 1
      @symbol   = @input[@position, 1]
      Token.new(:STRING, match[1])
    else
      raise "Encountered a non-terminated string"
    end
  end
  
  def consume_number
    returning(Token.new(:NUMBER, @symbol)) do |token|
      while !eof? && /[0-9]/ =~ @symbol || (/\./ =~ @symbol && !number.include?(".") && /[0-9]/ =~ @input[@position + 1, 1])
        token.text << @symbol
      end
    end
  end
  
  def consume_message
    returning(Token.new(:MESSAGE, @symbol)) do |token|
      while !eof? && /[a-zA-Z\?]/ =~ @symbol
        token.text << @symbol 
      end
    end
  end
  
  def consume_binary_message
    returning(Token.new(:BINARY_MESSAGE, @symbol)) do |token|
      while BINARY_MESSAGE =~ consume
        token.text << @symbol
      end
    end
  end
  
  def eof?
    @symbol == :EOF
  end
end