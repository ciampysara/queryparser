package tests

import (
	"fmt"
	"github.com/publicocean0/queryparser"
	"testing"
)

type A interface{}
type AImpl struct {
	a string
}

func TestMain(m *testing.M) {

	q, error := queryparser.Parse(" 2019-02-05T10:10:90+4 ")
	if error != nil {
		fmt.Println(error)
		return
	}
	fmt.Println(*q)

}
