class Lexer
  include Consumers
  
  BINARY_REGEX = /&|\||!|<|=|>|\+|-|\*|\/|%|\^/  
  
  def initialize(input)
    @input    = input
    @position = 0
    @symbol   = @input.size.zero? ? :EOF : input[@position, 1]
  end
  
  def run
    returning([]) { |tokens| (tokens << next_token).compact! while tokens.empty? || tokens.last.type != :EOF }
  end
  
  private
  
  def next_token
    case @symbol
    when :EOF: Token.new(:EOF, "EOF")
    when /\s/:         consume_whitespace
    when /"/:          consume_string
    when /[0-9]/:      consume_number
    when /[a-zA-Z]/:   consume_message
    when BINARY_REGEX: consume_binary_message
    when /:/:          consume && Token.new(:COLON, ":")
    when /\./:         consume && Token.new(:DOT, ".")
    when /\,/:         consume && Token.new(:COMMA, ",")
    when /\(/:         consume && Token.new(:LPAREN, "(")
    when /\)/:         consume && Token.new(:RPAREN, ")")
    when /\[/:         consume && Token.new(:LBRACKET, "[")
    when /\]/:         consume && Token.new(:RBRACKET, "]")
    when /\{/:         consume && Token.new(:LSQUIQ, "{")
    when /\}/:         consume && Token.new(:RSQUIG, "}")
    else raise "Invalid character: #{@symbol}"
    end
  end
  
  def consume
    @symbol = ((@position += 1) >= @input.length ? :EOF : @input[@position, 1])
  end
end