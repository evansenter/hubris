module Consumers
  BINARY_REGEX = /&|\||!|<|=|>|\+|-|\*|\/|%|\^/
  KEY_TOKENS   = {
    ":" => :COLON,
    "." => :DOT,
    "," => :COMMA,
    "(" => :L_PAREN,
    ")" => :R_PAREN,
    "[" => :L_BRACKET,
    "]" => :R_BRACKET,
    "{" => :L_SQUIG,
    "}" => :R_SQUIG
  }
  
  def consume_whitespace
    consume while @symbol && /\s|\t/ =~ @symbol
  end
  
  def consume_string
    @tokens << returning(Token.new(:STRING, "")) do |token|
      while consume && /"/ !~ @symbol
        token.text << @symbol
      end
      consume if @symbol
    end
  end
  
  def consume_number
    @tokens << returning(Token.new(:INTEGER, @symbol)) do |token|
      while consume && (/[0-9]/ =~ @symbol || becoming_a_float?(token))
        token.text << @symbol
      end
    end
  end
  
  def consume_message
    @tokens << returning(Token.new(:MESSAGE, @symbol)) do |token|
      while consume && /[a-zA-Z0-9_\?]/ =~ @symbol
        token.text << @symbol 
      end
    end
  end
  
  def consume_binary_message
    @tokens << returning(Token.new(:BINARY_MESSAGE, @symbol)) do |token|
      while consume && BINARY_REGEX =~ @symbol
        token.text << @symbol
      end
    end
  end
  
  def consume_symbol
    @tokens << Token.new(KEY_TOKENS[@symbol], @symbol)
    consume
  end
  
  private
  
  def next_token
    case @symbol
    when nil:     @tokens << Token.new(:EOF, "EOF")
    when /\s|\t/:     consume_whitespace
    when /"/:         consume_string
    when /[0-9]/:     consume_number
    when /[a-zA-Z_]/: consume_message
    else 
      if /-/ =~ @symbol && /[0-9]/ =~ lookahead(1)
        consume_number
      elsif BINARY_REGEX =~ @symbol
        consume_binary_message
      elsif KEY_TOKENS.keys.include?(@symbol)
        consume_symbol
      else
        raise "Invalid character: #{@symbol}"
      end
    end
  end
  
  def becoming_a_float?(token)
    returning(/\./ =~ @symbol && !token.text.include?(".") && /[0-9]/ =~ lookahead(1)) do |is_float|
      token.type = :FLOAT if is_float
    end
  end
end