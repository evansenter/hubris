require File.join(File.dirname(__FILE__), "..", "test_helper.rb")

class ConsumersTest < Test::Unit::TestCase  
  def test_consume_whitespace
    assert_lex(" ")
    assert_lex("\t")
    assert_lex(" \t")
  end
  
  def test_consume_string__empty_case
    assert_lex('""', :string, "")
  end
  
  def test_consume_string__base_case
    assert_lex('"Dinosaur"', :string, "Dinosaur")
  end
  
  def test_consume_number__positive_integer
    assert_lex("010", :integer, "010")
  end
  
  def test_consume_number__negative_integer
    assert_lex("-010", :integer, "-010")
  end
  
  def test_consume_number__positive_float
    assert_lex("010.010", :float, "010.010")
  end
  
  def test_consume_number__negative_float
    assert_lex("-010.010", :float, "-010.010")
  end
  
  def test_consume_message
    assert_lex("message", :message, "message")
  end
  
  def test_consume_message__starts_with_capital_letter
    assert_lex("CrypticMessage", :message, "CrypticMessage")
  end
  
  def test_consume_message__starts_with_underscore
    assert_lex("_cryptic_message", :message, "_cryptic_message")
  end
  
  def test_consume_message__contains_number
    assert_lex("Cryptic_Message_1", :message, "Cryptic_Message_1")
  end
  
  def test_consume_message__contains_question_mark
    assert_lex("Cryptic?Message?1?", :message, "Cryptic?Message?1?")
  end
  
  def test_consume_binary_message__base_case
    assert_lex("&", :binary_message, "&")
  end
  
  def test_consume_binary_message__multiple_characters
    assert_lex("&&", :binary_message, "&&")
  end
  
  def test_consume_symbol
    assert_lex("[", :l_bracket, "[")
  end
end