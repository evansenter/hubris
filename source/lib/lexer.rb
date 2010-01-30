class Lexer
  include Consumers
  
  def initialize(input)
    @input    = input
    @position = 0
    @symbol   = @input.size.zero? ? nil : input[@position, 1]
    @tokens   = []
  end
  
  def run
    returning(@tokens) { next_token while @tokens.empty? || @tokens.last.type != :eof }
  end
  
  private
  
  def lookahead(distance)
    @input[@position + distance, 1]
  end
  
  def consume
    @symbol = ((@position += 1) >= @input.length ? nil : @input[@position, 1])
  end
end