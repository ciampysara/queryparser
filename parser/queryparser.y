// Author 2020 Cristian Lorenzetto. 


%{

package parser

import (

	

     "time"
	"strconv"
	"regexp"
	"github.com/publicocean0/queryparser/common"
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
%token <token> DATE
%token <token> DATETIME
%token <token> TIME

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
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:$3.Literal}}
} 
| IDENT NEQ STRING 
{
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:$3.Literal}}
} 
| IDENT LIKE STRING 
{
$$ =common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:$3.Literal}}
} 
| IDENT NLIKE STRING 
{
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:$3.Literal}}
} 
| IDENT EQ BOOL 
{
b, _ := strconv.ParseBool($3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:b}}
} 
| IDENT NEQ BOOL
{
b, _ := strconv.ParseBool($3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:b}}
}
| IDENT EQ INT
{
i, _ := strconv.ParseInt($3.Literal, 10, 64)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:i}}

}
| IDENT NEQ INT
{
i, _ := strconv.ParseInt($3.Literal, 10, 64)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:i}}

}
| IDENT EQ FLOAT
{
f, _ := strconv.ParseFloat($3.Literal,  64)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:f}}

}
| IDENT NEQ FLOAT
{
f, _ := strconv.ParseFloat($3.Literal,  64)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:f}}

}
| IDENT GT INT
{
i, _ := strconv.ParseInt($3.Literal, 10, 64)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:i}}

}
| IDENT LT INT
{
i, _ := strconv.ParseInt($3.Literal, 10, 64)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:i}}

}
| IDENT GT FLOAT
{
f, _ := strconv.ParseFloat($3.Literal,  64)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:f}}

}
| IDENT LT FLOAT
{
f, _ := strconv.ParseFloat($3.Literal,  64)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:f}}

}
| IDENT GTE INT
{
i, _ := strconv.ParseInt($3.Literal, 10, 64)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:i}}

}
| IDENT LTE INT
{
i, _ := strconv.ParseInt($3.Literal, 10, 64)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:i}}

}
| IDENT GTE FLOAT
{
f, _ := strconv.ParseFloat($3.Literal,  64)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:f}}

}
| IDENT LTE FLOAT
{
f, _ := strconv.ParseFloat($3.Literal,  64)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:f}}

}
| IDENT EQ DATE
{
t, _ := common.Date.Parse($3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT EQ DATETIME
{
t, _ := time.Parse(time.RFC3339, $3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT EQ TIME
{
t, _ := time.Parse(time.RFC3339, "1970-01-01T"+$3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT NEQ DATE
{
t, _ := time.Parse(time.RFC3339, $3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT  NEQ  DATETIME
{
t, _ := time.Parse(time.RFC3339, $3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT NEQ TIME
{
t, _ := time.Parse(time.RFC3339, "1970-01-01T"+$3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT LT DATE
{
t, _ := time.Parse(time.RFC3339, $3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT  LT  DATETIME
{
t, _ := time.Parse(time.RFC3339, $3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT LT TIME
{
t, _ := time.Parse(time.RFC3339, "1970-01-01T"+$3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT GT DATE
{
t, _ := time.Parse(time.RFC3339, $3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT  GT  DATETIME
{
t, _ := time.Parse(time.RFC3339, $3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT GT TIME
{
t, _ := time.Parse(time.RFC3339, "1970-01-01T"+$3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT LTE DATE
{
t, _ := time.Parse(time.RFC3339, $3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT  LTE  DATETIME
{
t, _ := time.Parse(time.RFC3339, $3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT LTE TIME
{
t, _ := time.Parse(time.RFC3339, "1970-01-01T"+$3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT GTE DATE
{
t, _ := time.Parse(time.RFC3339, $3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT  GTE  DATETIME
{
t, _ := time.Parse(time.RFC3339, $3.Literal)
$$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}

}
| IDENT GTE TIME
{
t, e := time.Parse(time.RFC3339, "1970-01-01T"+$3.Literal)
if e != nil {
	//(&(Querylex.(QueryLexerImpl))).SetLastParsedToken(&QueryDollar[3].token)
			
Querylex.Error(e.Error() + " at " + strconv.Itoa(QueryDollar[3].token.Position))
break;
} else {
    $$ = common.Condition{Variable:$1,Comparator:$2,Value:common.TokenValue{Token:$3.Token,Content:t}}
}
}
;



%%      /*  start  of  programs  */

type QueryLexerImpl struct {
	src             string
	pos             int
	re              *regexp.Regexp
	Exception       *common.Exception
	AST             common.Expression
	lastParsedToken *common.Token
}

func (l *QueryLexerImpl) PositionedError(pos int,msg string) {
	
}

func (l *QueryLexerImpl) Init(src string) {
	l.src = src
	l.pos = 0
	l.re = regexp.MustCompile(`^((?P<op>((OR)|(NOT)|(AND)))|(?P<comp>((\!\=)|(\!\~)|(\<\=)|(\>\=)|(\=)|(\~)|(\>)|(\<)))|(?P<bool>((true)|(false)))|(?P<string>\"(?:[^"\\]|\\.)*\")|(?P<ident>[A-Za-z]\w*)|(?P<time>((\d{4}\-\d{2}\-\d{2})(T(\d{1,2}\:\d{2}((\:\d{2}(\:\d{2})?)?)(([-+]\d{2}\:\d{2})|Z)?))?)|(\d{1,2}\:\d{2}((\:\d{2}(\:\d{2})?)?)(([-+]\d{2}\:\d{2})|Z)?))|(?P<number>([-+]?\d+)(\.\d+)?))`)
}

func (l *QueryLexerImpl) Lex(lval *QuerySymType) int {
	var t int = -1
	len := len(l.src)
	// remove all spaces on the left
	for l.pos < len && (l.src[l.pos] == ' ' || l.src[l.pos] == '\t') {
		l.pos++

	}
	if l.pos == len {
		return -1
	}

	if l.src[l.pos] == '(' {
		t = LPAREN
		lval.token = common.Token{Position: l.pos, Token: t, Literal: "("}
		l.pos++
		return t
	} else if l.src[l.pos] == ')' {
		t = RPAREN
		lval.token = common.Token{Position: l.pos, Token: t, Literal: ")"}
		l.pos++
		return t
	}
	//find the leftmost token (and its subtokens)
	result := l.re.FindSubmatchIndex([]byte(l.src[l.pos:]))
	if result == nil {
		return -1
	}
	for pairIndex := 2; t == -1 && pairIndex < 84; pairIndex += 2 {

		rstart := result[pairIndex]
		if rstart != -1 {
			start := l.pos + result[pairIndex]
			switch pairIndex {
			// comparator
			case 18:
				t = NEQ
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: "!="}
				break
			case 20:
				t = NLIKE
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: "!~"}
				break
			case 22:
				t = LTE
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: "<="}
				break
			case 24:
				t = GTE
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: ">="}
				break
			case 26:
				t = EQ
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: "="}
				break
			case 28:
				t = LIKE
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: "~"}
				break
			case 30:
				t = GT
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: ">"}
				break
			case 32:
				t = LT
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: "<"}
				break
			case 78:
				if result[82] != -1 {
					t = FLOAT
				} else {
					t = INT
				}
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: l.src[start : l.pos+result[pairIndex+1]]}
				break
				// string
			case 42: //SHIFT
				t = STRING
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: l.src[start+1 : l.pos+result[pairIndex+1]-1]}
				break
			case 8:
				t = OR
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: "OR"}
				break
			case 10:
				t = NOT
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: "NOT"}
				break
			case 12:
				t = AND
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: "AND"}
				break
			case 36:
				t = BOOL
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: l.src[start : l.pos+result[pairIndex+1]]}
				break
			case 44: // gia' sfhittato
				t = IDENT
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: l.src[start : l.pos+result[pairIndex+1]]}
				break
			case 66:
				t = TIME
				s := ""
				var index = pairIndex + 1
				if result[70] == -1 {
					s += ":00"
					if result[74] != -1 {
						s += l.src[l.pos+result[74] : l.pos+result[75]]
						index = 74
					}
				}
				if result[74] == -1 {
					s += "+00:00"
				} else if (l.src[result[74]]=='Z'){
					index--
					s += "+00:00"
				}
				lval.token = common.Token{Position: l.pos + start, Token: t, Literal: l.src[start:l.pos+result[index]] + s}
				break
			case 48:
				s := ""
				if result[52] != -1 {
					t = DATETIME
					var index = pairIndex + 1
					if result[58] == -1 {
						s = ":00"
						if result[62] != -1 {
							s += l.src[l.pos+result[62] : l.pos+result[63]]
							index = 62
						}
					}
					if result[62] == -1 {
						s += "+00:00"
					}else if (l.src[result[62]]=='Z'){
						index--
						s += "+00:00"
					}

					lval.token = common.Token{Position: l.pos + start, Token: t, Literal: l.src[start:l.pos+result[index]] + s}

				} else {
					t = DATE
					s += "T00:00:00+00:00"
					lval.token = common.Token{Position: l.pos + start, Token: t, Literal: l.src[start:l.pos+result[pairIndex+1]] + s}
				}

				break

			}
			if t != -1 {
				l.pos += result[pairIndex+1]
				if l.pos != len && l.src[l.pos] != ' ' {
					t = -1
					l.pos -= result[pairIndex+1]
					l.lastParsedToken = nil
					return t
				}
			}

		}

	}

	return t
}

func (l *QueryLexerImpl) Error(e string) {
	l.Exception = &common.Exception{}

	if l.lastParsedToken == nil {
		s := l.src[l.pos:]
		l.Exception.Init(l.pos, e+" at "+s)
	} else {
		s := l.src[l.lastParsedToken.Position:]
		l.Exception.Init(l.pos, e+" at "+s)
	}
}


