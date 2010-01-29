module Consumers
  def consume_whitespace
    consume while /\s/ =~ consume
  end
  
  def consume_string
    returning(Token.new(:STRING, "")) do |token|
      while /"/ !~ consume || (/\\/ =~ string[-1, 1])
        token.text << @symbol
      end
    end
  end
  
  def consume_number
    returning(Token.new(:NUMBER, @symbol)) do |token|
      while consume != :EOF && /[0-9]/ =~ @symbol || (/\./ =~ @symbol && !number.include?(".") && /[0-9]/ =~ @input[@position + 1, 1])
        token.text << @symbol
      end
    end
  end
  
  def consume_message
    returning(Token.new(:MESSAGE, @symbol)) do |token|
      while consume != :EOF && /[a-zA-Z\?]/ =~ @symbol
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
end