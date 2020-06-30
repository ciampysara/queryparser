package queryparser

import (
	"queryparser/common"
	"queryparser/internal"

	"strings"
)

func Parse(qs string) (*common.Expression, *common.Exception) {
	q := internal.QueryLexerImpl{}
	q.Init(strings.NewReader(qs))
	internal.QueryParse(&q)
	if q.ErrorCount > 0 {
		return nil, &q.Errors[0]
	}
	return &q.AST, nil
}
