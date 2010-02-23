class Node
  attr_reader :token, :children
  
  def initialize(token, *children)
    @token    = token
    @children = children
  end
end