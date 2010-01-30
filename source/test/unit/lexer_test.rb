require File.join(File.dirname(__FILE__), "..", "test_helper.rb")

class LexerTest < Test::Unit::TestCase
  def test_run_with_no_args
    assert_equal [eof], lex("")
  end
  
  def test_consume_whitespace
    assert_equal [eof], lex(" ")
    assert_equal [eof], lex("\t")
    assert_equal [eof], lex(" \t")
  end
  
  def test_consume_string__empty_case
    assert_equal [token(:STRING, ''), eof], lex('""')
  end
  
  def test_consume_string__base_case
    assert_equal [token(:STRING, 'Dinosaur'), eof], lex('"Dinosaur"')
  end
  
  def test_consume_string__escaped_inner_quote
    assert_equal [token(:STRING, 'Dino\"saur'), eof], lex('"Dino\"saur"')
  end
  
  private
  
  def lex(string)
    Lexer.new(string).run
  end
  
  def token(type, text)
    Token.new(type, text)
  end
  
  def eof
    token(:EOF, "EOF")
  end
end