# queryparser

Parser per building a dinamic conditional expression

The syntax is similar to sql where condition:
 - type accepted: int,float,boolean,string(with double quote delimiters),date(yyyy-mm-dd), time(hh:mm(:ss([+-]hh:mm))), datetime, duration(time without timezone starting with + or -)
 - variable with letter,digit or underscore
 - comparator =,!=,<,>,>=,<=,~(match), !~(NOT MATCH)
 - boolean operators: AND, OR, NOT
 

`ast,error:=Parse(query) `

AST can be navigated for generating the final command and evoiding sql injection

PS. The rest backend must have a jwt token for blocking not permitted access to generic filters
 
