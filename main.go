package queryparser

import (
	"github.com/publicocean0/queryparser/common"
	"github.com/publicocean0/queryparser/parser"

	"strings"
)

func Parse(qs string) (*common.Expression, *common.Exception) {
	q := parser.QueryLexerImpl{}
	q.Init(strings.NewReader(qs))
	parser.QueryParse(&q)
	if q.ErrorCount > 0 {
		return nil, &q.Errors[0]
	}
	return &q.AST, nil
}
