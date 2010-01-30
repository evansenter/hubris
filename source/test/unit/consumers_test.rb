require File.join(File.dirname(__FILE__), "..", "test_helper.rb")

class ConsumersTest < Test::Unit::TestCase  
  def test_consume_whitespace
    assert_lex(" ")
    assert_lex("\t")
    assert_lex(" \t")
  end
  
  def test_consume_string__empty_case
    assert_lex('""', :STRING, "")
  end
  
  def test_consume_string__base_case
    assert_lex('"Dinosaur"', :STRING, "Dinosaur")
  end
  
  def test_consume_number__positive_integer
    assert_lex("010", :INTEGER, "010")
  end
  
  def test_consume_number__negative_integer
    assert_lex("-010", :INTEGER, "-010")
  end
  
  def test_consume_number__positive_float
    assert_lex("010.010", :FLOAT, "010.010")
  end
  
  def test_consume_number__negative_float
    assert_lex("-010.010", :FLOAT, "-010.010")
  end
  
  def test_consume_message
    assert_lex("message", :MESSAGE, "message")
  end
  
  def test_consume_message__starts_with_capital_letter
    assert_lex("CrypticMessage", :MESSAGE, "CrypticMessage")
  end
  
  def test_consume_message__starts_with_underscore
    assert_lex("_cryptic_message", :MESSAGE, "_cryptic_message")
  end
  
  def test_consume_message__contains_number
    assert_lex("Cryptic_Message_1", :MESSAGE, "Cryptic_Message_1")
  end
  
  def test_consume_message__contains_question_mark
    assert_lex("Cryptic?Message?1?", :MESSAGE, "Cryptic?Message?1?")
  end
  
  def test_consume_binary_message__base_case
    assert_lex("&", :BINARY_MESSAGE, "&")
  end
  
  def test_consume_binary_message__multiple_characters
    assert_lex("&&", :BINARY_MESSAGE, "&&")
  end
  
  def test_consume_symbol
    assert_lex("[", :L_BRACKET, "[")
  end
end