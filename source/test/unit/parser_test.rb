require File.join(File.dirname(__FILE__), "..", "test_helper.rb")

class ParserTest < Test::Unit::TestCase
  def setup
    # @parser = Parser.new
  end
  
  def test_parser
    Node.new(token(:binary_message, "+"), [
      token(:integer, "2"),
      token(:integer, "2")
    ])
  end
end