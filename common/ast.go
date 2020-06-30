package common

type Token struct {
	Token   int
	Literal string
}

type Condition struct {
	Variable   Token
	Comparator Token
	Value      Token
}

func (l Condition) String() string {
	return l.Variable.Literal + " " + l.Comparator.Literal + " " + l.Value.Literal
}

type Expression interface {
	String() string
}

type SubExpression struct {
	Expr Expression
}

func (l SubExpression) String() string {
	return "(" + (l.Expr).String() + ")"
}

type NotExpression struct {
	Expr Expression
}

func (l NotExpression) String() string {
	return "(" + (l.Expr).String() + ")"
}

type BiExpression struct {
	BooleanOperator Token
	Left            Expression
	Right           Expression
}

func (l BiExpression) String() string {
	return (l.Left).String() + " " + (l.BooleanOperator).Literal + " " + (l.Right).String()
}
