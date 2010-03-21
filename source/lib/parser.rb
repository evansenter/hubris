class Parser
  include StateParsers
  
  def initialize(tokens)
    @tokens      = tokens
    @position    = 0
    @markers     = []
    @memoization = {}
  end

  def mark
    @markers << @position
  end
  
  def release
    @position = @markers.pop
  end
  
  def speculating?
    !@markers.empty?
  end
  
  def parsed_rule?
    case memoized_position = @memoization[@position]
    when nil   then return false
    when false then raise ParseFailedException
    else @position = memoized_position
    end
  end
  
  def memoize(start_position, final_state)
    @memoization[start_position] = final_state
  end
end