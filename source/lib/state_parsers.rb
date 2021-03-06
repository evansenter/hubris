module StateParsers
  def statement
    if speculate_state_1
      state_1
    elsif speculate_state_2
      state_2
    else
      raise NoViableStatementException
    end
  end
end

# grammar Hubris
#   rule root
#     terminator? expressions? eof
#   end
#   
#   rule expressions
#     expression (terminator expression)* terminator?
#   end
#   
#   rule expression
#     literal / call / function_definition / object_definition
#   end
#   
#   rule literal
#     float / integer / string
#   end
#   
#   rule call
#     unary_call / binary_call / argument_call
#   end
#   
#   rule unary_call
#     message message / message
#   end
#   
#   rule binary_call
#     message binary_message / binary_message
#   end
#   
#   rule argument_call
#     message message arguments / message arguments
#   end
#   
#   rule arguments
#     "(" message ("," message)* ")"
#   end
#   
#   rule function_definition
#     "[" (function_arguments "|")? expressions? "]"
#   end
#   
#   rule function_arguments
#     message ("," message)*
#   end
#   
#   rule object_definition
#     "{" expressions? "}"
#   end
#   
#   # Helpers.
#   
#   rule message
#     [a-z]+
#   end
#   
#   rule binary_message
#     ("&" / "|" / "<" / "=" / ">" / "+" / "-" / "*" / "/" / "%" / "^")+
#   end
#   
#   rule float
#     [0-9]+ "." [0-9]+
#   end
#   
#   rule integer
#     [0-9]+
#   end
#   
#   rule string
#     '"' ('\"' / !'"' .)* '"'
#   end
#   
#   rule terminator
#     ("\r"? "\n")+
#   end
#   
#   rule eof
#     !.
#   end
# end
