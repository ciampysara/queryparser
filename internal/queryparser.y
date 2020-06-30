// Author 2020 Cristian Lorenzetto. 


%{

package internal

import (

	


	"io"
     "strings"
     "unicode"
	"text/scanner"
	"queryparser/common"
)



%}
// fields inside this union end up as the fields in a structure known
// as ${PREFIX}SymType, of which a reference is passed to the lexer.
%union{
	expr  common.Expression
    cond common.Condition
	token common.Token
}

%token <token> IDENT
%token <token> STRING
%token <token> INT
%token <token> FLOAT
%token <token> BOOL
%token <token> EQ
%token <token> NEQ
%token <token> LT
%token <token> GT
%token <token> LTE
%token <token> GTE
%token <token> LPAREN
%token <token> RPAREN
%token <token> AND 
%token <token> NOT
%token <token> OR
%token <token> LIKE
%token <token> NLIKE

%type <expr> expr
%type <cond> condition

%left AND
%left OR
%left NOT


%%

expr : condition {
	$$ =$1
	Querylex.(*QueryLexerImpl).AST = $$

} 
| LPAREN expr RPAREN 
{   
	$$ = common.SubExpression{Expr:$2}
	Querylex.(*QueryLexerImpl).AST = $$

}
|  NOT expr  %prec NOT {
	$$ = common.NotExpression{Expr:$2}
	Querylex.(*QueryLexerImpl).AST = $$
}
| expr AND expr {
	$$ = common.BiExpression{BooleanOperator:$2,Left:$1,Right:$3}
    Querylex.(*QueryLexerImpl).AST = $$

}
| expr OR expr {
	$$ = common.BiExpression{BooleanOperator:$2,Left:$1,Right:$3}
	Querylex.(*QueryLexerImpl) .AST= $$
}
;


condition :  IDENT EQ STRING 
{
$$ = common.Condition{Variable:$1,Comparator:$2,Value:$3}
} 
| IDENT NEQ STRING 
{
$$ = common.Condition{Variable:$1,Comparator:$2,Value:$3}
} 
| IDENT LIKE STRING 
{
$$ =common.Condition{Variable:$1,Comparator:$2,Value:$3}
} 
| IDENT NLIKE STRING 
{
$$ = common.Condition{Variable:$1,Comparator:$2,Value:$3}
} 
| IDENT EQ BOOL 
{
$$ = common.Condition{Variable:$1,Comparator:$2,Value:$3}
} 
| IDENT NEQ BOOL
{
 $$ = common.Condition{Variable:$1,Comparator:$2,Value:$3}
}
| IDENT EQ INT
{
$$ = common.Condition{Variable:$1,Comparator:$2,Value:$3}
}
| IDENT NEQ INT
{
$$ = common.Condition{Variable:$1,Comparator:$2,Value:$3}
}
| IDENT EQ FLOAT
{
$$ = common.Condition{Variable:$1,Comparator:$2,Value:$3}
}
| IDENT NEQ FLOAT
{
$$ =common. Condition{Variable:$1,Comparator:$2,Value:$3}
}
| IDENT GT INT
{
$$ = common.Condition{Variable:$1,Comparator:$2,Value:$3}
}
| IDENT LT INT
{
$$ = common.Condition{Variable:$1,Comparator:$2,Value:$3}
}
| IDENT GT FLOAT
{
$$ = common.Condition{Variable:$1,Comparator:$2,Value:$3}
}
| IDENT LT FLOAT
{
$$ = common.Condition{Variable:$1,Comparator:$2,Value:$3}
}
| IDENT GTE INT
{
$$ = common.Condition{Variable:$1,Comparator:$2,Value:$3}
}
| IDENT LTE INT
{
$$ =common. Condition{Variable:$1,Comparator:$2,Value:$3}
}
| IDENT GTE FLOAT
{
$$ =common. Condition{Variable:$1,Comparator:$2,Value:$3}
}
| IDENT LTE FLOAT
{
$$ =common. Condition{Variable:$1,Comparator:$2,Value:$3}
};



%%      /*  start  of  programs  */


type QueryLexerImpl struct {
	scanner.Scanner
	Errors []common.Exception
	AST common.Expression
}

func (l *QueryLexerImpl) Init(src io.Reader) *scanner.Scanner {
	l.Scanner.Init(src)
	l.Scanner.Mode = scanner.ScanIdents | scanner.ScanInts | scanner.ScanFloats | scanner.ScanChars | scanner.ScanStrings | scanner.ScanRawStrings | scanner.SkipComments
	l.Scanner.IsIdentRune = func(ch rune, i int) bool {
		return ch == '_' || ((ch == '<' || ch == '>' || ch == '!') && i == 0) || ((ch == '=' || ch == '~') && i < 2) || unicode.IsLetter(ch) || (unicode.IsDigit(ch) && i > 0)
	}
	l.Scanner.Error = func(s *scanner.Scanner, msg string) {
        c:=common.Exception{}
        c.Init(s.Column,msg)
		l.Errors = append(l.Errors, c)
	}
	return &l.Scanner
}

func (l *QueryLexerImpl) Lex(lval *QuerySymType) int {
	t := int(l.Scan())
	s := l.TokenText()

	if t == scanner.EOF {
		return t
	}
	st := rune(t)
	if st == '(' {
		t = LPAREN
	}
	if st == ')' {
		t = RPAREN
	}
	if t == scanner.Ident && !strings.ContainsAny(s,"><=!~") {
		t = IDENT
	}
	if t == scanner.String {
		t = STRING
		s = s[1 : len(s)-1]
	}
	if t == scanner.Int {
		t = INT
	}
	if t == scanner.Float {
		t = FLOAT
	}
	if s == "=" {
		t = EQ
	}
	if s == "!=" {
		t = NEQ
	}
	if s == "~" {
		t = LIKE
	}
	if s == "!~" {
		t = NLIKE
	}
	if s == "<" {
		t = LT
	}
	if s == "<=" {
		t = LT
	}
	if s == ">" {
		t = LT
	}
	if s == ">=" {
		t = LT
	}
	if s == "true" {
		t = BOOL
	}
	if s == "false" {
		t = BOOL
	}
	if s == "AND" {
		t = AND
	}
	if s == "OR" {
		t = OR
	}

	lval.token = common.Token{Token: t, Literal: s}

	return t
}

func (l *QueryLexerImpl) Error(e string) {
	l.Scanner.ErrorCount++
	l.Scanner.Error(&(l.Scanner), e)
}






