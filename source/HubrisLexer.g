lexer grammar HubrisLexer;

THIS	:	'this';
TRUE	:	'true';
FALSE	:	'false';
NULL	:	'null';

INTEGER	:	SIGN? DIGIT;
FLOAT	:	INTEGER CALL DIGIT;
STRING	:	'"' ~('\\' | '"')* '"';

ASSIGN_LOC
	:	'=';
ASSIGN_KEY
	:	':=';

BINARY_MESSAGE
	:	('&' | '|' | '<' | '=' | '>' | '+' | '-' | '*' | '/' | '%' | '^')+;
MESSAGE	:	(LETTER | '_') MESSAGE_SYMBOL* ('!'|'?')?;

CALL	:	'.';
COMMA	:	',';
L_ARRAY	:	'#(';
L_PAREN	:	'(';
R_PAREN	:	')';
L_BRACK	:	'[';
R_BRACK	:	']';

COMMENT	:	'#' ~('\r' | '\n')* (NEWLINE | EOF) { skip(); };
NEWLINE	:	'\r'? '\n';
WHITESPACE
	:	(' ' | '\t')+ { $channel = HIDDEN; };

fragment MESSAGE_SYMBOL
	:	LETTER | DIGIT | '_';
fragment LETTER
	:	LOWER | UPPER;
fragment LOWER
	:	'a'..'z'+;
fragment UPPER
	:	'A'..'Z'+;
fragment DIGIT
	:	'0'..'9'+;
fragment SIGN
	:	'+' | '-';