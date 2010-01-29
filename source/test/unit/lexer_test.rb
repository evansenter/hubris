require File.join(File.dirname(__FILE__), "..", "test_helper.rb")

class LexerTest < Test::Unit::TestCase
  def test_run_with_no_args
    lexer = Lexer.new("")
    assert_equal [eof], lexer.run
  end
  
  private
  
  def token(type, text)
    Token.new(type, text)
  end
  
  def eof
    token(:EOF, "EOF")
  end
end