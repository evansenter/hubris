class Object
  def returning(object)
    yield object
    object
  end
end

class Lexer
  TOKEN = Struct.new(:type, :text)
  
  def initialize(input)
    @input    = input
    @position = 0
    @symbol   = @input.size.zero? ? :EOF : input[@position, 1]
  end
  
  def consume
    @symbol = ((@position += 1) >= @input.length ? :EOF : @input[@position, 1])
  end
  
  def run
    returning([]) { |tokens| (tokens << next_token).compact! while tokens.empty? || tokens.last.type != :EOF }
  end
end

class HubrisLexer < Lexer
  BINARY_REGEX = /&|\||!|<|=|>|\+|-|\*|\/|%|\^/
  
  def next_token
    case @symbol
    when :EOF: TOKEN.new(:EOF, "EOF")
    when /\s/:         consume_whitespace
    when /"/:          consume_string
    when /[0-9]/:      consume_number
    when /[a-zA-Z]/:   consume_message
    when BINARY_REGEX: consume_binary_message
    when /:/:          consume && TOKEN.new(:COLON, ":")
    when /\./:         consume && TOKEN.new(:DOT, ".")
    when /\,/:         consume && TOKEN.new(:COMMA, ",")
    when /\(/:         consume && TOKEN.new(:LPAREN, "(")
    when /\)/:         consume && TOKEN.new(:RPAREN, ")")
    when /\[/:         consume && TOKEN.new(:LBRACKET, "[")
    when /\]/:         consume && TOKEN.new(:RBRACKET, "]")
    when /\{/:         consume && TOKEN.new(:LSQUIQ, "{")
    when /\}/:         consume && TOKEN.new(:RSQUIG, "}")
    else raise "Invalid character: #{@symbol}"
    end
  end
  
  def consume_whitespace
    consume while /\s/ =~ consume
  end
  
  def consume_string
    returning(TOKEN.new(:STRING, "")) do |token|
      while /"/ !~ consume || (/\\/ =~ string[-1, 1])
        token.text << @symbol
      end
    end
  end
  
  def consume_number
    returning(TOKEN.new(:NUMBER, @symbol)) do |token|
      while /[0-9]/ =~ consume || (/\./ =~ @symbol && !number.include?(".") && /[0-9]/ =~ @input[@position + 1, 1])
        token.text << @symbol
      end
    end
  end
  
  def consume_message
    returning(TOKEN.new(:MESSAGE, @symbol)) do |token|
      token.text << @symbol while /[a-zA-Z\?]/ =~ consume
    end
  end
  
  def consume_binary_message
    returning(TOKEN.new(:BINARY_MESSAGE, @symbol)) do |token|
      token.text << @symbol while BINARY_MESSAGE =~ consume
    end
  end
end

test_string = "[ab, cd, [ef, gh], ij]"
test_string = ""
lexer       = HubrisLexer.new(test_string)
tokens      = lexer.run

tokens.each { |token| p token }