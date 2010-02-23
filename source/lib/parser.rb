class Parser
  def initialize(tokens)
    @tokens   = tokens
    @position = 0
  end
  
  def build_ast
    while @position < @tokens.length && !eof?
      parse
    end
  end
  
  def parse
    
  end
  
  def eof?
    @tokens[@position].type == :eof
  end
end