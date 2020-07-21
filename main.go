package queryparser

import (
	"github.com/publicocean0/queryparser/Common"
	"github.com/publicocean0/queryparser/parser"
)

func Parse(qs string) (*Common.Expression, *Common.Exception) {
	q := parser.QueryLexerImpl{}
	q.Init(qs)
	parser.QueryParse(&q)
	if q.Exception != nil {
		return nil, q.Exception
	}
	return &q.AST, nil
}
