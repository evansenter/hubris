require File.join(File.dirname(__FILE__), "..", "test_helper.rb")

class LexerTest < Test::Unit::TestCase
  def test_run_with_no_args
    assert_lex("")
  end
  
  def test_string_receiving_message
    assert_lex('"Dinosaurs" capitalize', [:STRING, "Dinosaurs"], [:MESSAGE, "capitalize"])
  end
  
  def test_message_receiving_message
    assert_lex("dinosaurs capitalize", [:MESSAGE, "dinosaurs"], [:MESSAGE, "capitalize"])
  end
  
  def test_arithmetic
    assert_lex("1 + 1", [:INTEGER, "1"], [:BINARY_MESSAGE, "+"], [:INTEGER, "1"])
  end
  
  def test_arithmetic_with_mixed_types_and_signs
    assert_lex("-1 + 1.0", [:INTEGER, "-1"], [:BINARY_MESSAGE, "+"], [:FLOAT, "1.0"])
  end
  
  def test_method_definition
    assert_lex("[ raptor ]", [:L_BRACKET, "["], [:MESSAGE, "raptor"], [:R_BRACKET, "]"])
  end
  
  def test_method_definition_with_parameters
    assert_lex("[ _raptor_1, Raptor2? : _raptor_1 + Raptor2? ]", 
      [:L_BRACKET,      "["], 
      [:MESSAGE,        "_raptor_1"], 
      [:COMMA,          ","],
      [:MESSAGE,        "Raptor2?"],
      [:COLON,          ":"],
      [:MESSAGE,        "_raptor_1"], 
      [:BINARY_MESSAGE, "+"],
      [:MESSAGE,        "Raptor2?"],
      [:R_BRACKET,      "]"]
    )
  end
end