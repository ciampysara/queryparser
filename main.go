package queryparser

import (
	"github.com/publicocean0/queryparser/common"
	"github.com/publicocean0/queryparser/parser"
)

func Parse(qs string) (*common.Expression, *common.Exception) {
	q := parser.QueryLexerImpl{}
	q.Init(qs)
	parser.QueryParse(&q)
	if q.Exception != nil {
		return nil, q.Exception
	}
	return &q.AST, nil
}
