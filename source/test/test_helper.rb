require "rubygems"
require "mocha"
require "test/unit"

require File.join(File.dirname(__FILE__), "..", "initializers", "runner.rb")

class Test::Unit::TestCase
  private
  
  def assert_lex(string, *args)
    token_list = args.flatten.each_slice(2).inject([]) { |tokens, token_type| tokens << token(*token_type) } << eof
    assert_equal token_list, lex(string)
  end
  
  def lex(string)
    Lexer.new(string).run
  end
  
  def token(type, text)
    Token.new(type, text)
  end
  
  def eof
    token(:eof, nil)
  end
end