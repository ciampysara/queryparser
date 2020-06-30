# queryparser

Parser per building a dinamic conditional expression

The syntax is similar to sql where condition:
 - type accepted: int,float,boolean,string
 - variable with letter,digit or underscore
 - comparator =,!=,<,>,>=,<=,~(match),!~
 - boolean operators: AND, OR, NOT
 

`ast,error:=Parse(query) `

AST can be navigated for generating the final command and evoiding sql injection

PS. The rest backend must have a jwt token for blocking not permitted access to generic filters
 
