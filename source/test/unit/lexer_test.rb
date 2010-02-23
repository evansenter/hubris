require File.join(File.dirname(__FILE__), "..", "test_helper.rb")

class LexerTest < Test::Unit::TestCase
  def test_run_with_no_args
    assert_lex("")
  end
  
  def test_object
    assert_lex('{}', [:l_squig, "{"], [:r_squig, "}"])
  end
  
  def test_string_receiving_message
    assert_lex('"Dinosaurs" capitalize', [:string, "Dinosaurs"], [:message, "capitalize"])
  end
  
  def test_message_receiving_message
    assert_lex("dinosaurs capitalize", [:message, "dinosaurs"], [:message, "capitalize"])
  end
  
  def test_arithmetic
    assert_lex("1 + 1", [:integer, "1"], [:binary_message, "+"], [:integer, "1"])
  end
  
  def test_arithmetic_with_mixed_types_and_signs
    assert_lex("-1 + 1.0", [:integer, "-1"], [:binary_message, "+"], [:float, "1.0"])
  end
  
  def test_function_definition
    assert_lex("[ raptor ]", [:l_bracket, "["], [:message, "raptor"], [:r_bracket, "]"])
  end
  
  def test_function_definition_with_parameters
    assert_lex("[ _raptor_1, Raptor2? : _raptor_1 + Raptor2? ]", 
      [:l_bracket,      "["], 
      [:message,        "_raptor_1"], 
      [:comma,          ","],
      [:message,        "Raptor2?"],
      [:colon,          ":"],
      [:message,        "_raptor_1"], 
      [:binary_message, "+"],
      [:message,        "Raptor2?"],
      [:r_bracket,      "]"]
    )
  end
  
  def test_first_order_function_call
    assert_lex("self some_function.", 
      [:message, "self"], 
      [:message, "some_function"], 
      [:dot,     "."]
    )
  end
  
  def test_function_call_with_args
    assert_lex("raptor(arg_1, arg_2)", 
      [:message, "raptor"], 
      [:l_paren, "("], 
      [:message, "arg_1"], 
      [:comma, ","],
      [:message, "arg_2"], 
      [:r_paren, ")"]
    )
  end
  
  def test_two_expressions_on_one_line
    assert_lex("self some_function; self another_function", 
      [:message, "self"], 
      [:message, "some_function"], 
      [:semicolon, ";"], 
      [:message, "self"], 
      [:message, "another_function"]
    )
  end
end