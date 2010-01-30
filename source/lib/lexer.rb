class Lexer
  include Consumers
  
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
  
  def initialize(input)
    @input    = input
    @position = 0
    @symbol   = @input.size.zero? ? nil : input[@position, 1]
  end
  
  def run
    # Refactor me.
    returning([]) { |tokens| (tokens << next_token).compact! while tokens.empty? || tokens.last.type != :EOF }
  end
  
  private
  
  def next_token
    case @symbol
    when nil:          Token.new(:EOF, "EOF")
    when /\s|\t/:      consume_whitespace
    when /"/:          consume_string
    when /[0-9]/:      consume_number
    when /[a-zA-Z]/:   consume_message
    when BINARY_REGEX: consume_binary_message
    else 
      if KEY_TOKENS.keys.include?(@symbol)
        Token.new(KEY_TOKENS[@symbol], symbol)
      else
        raise "Invalid character: #{@symbol}"
      end
    end
  end
  
  def consume
    @symbol = ((@position += 1) >= @input.length ? nil : @input[@position, 1])
  end
end