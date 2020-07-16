package tests

import (
	"fmt"
	"github.com/publicocean0/queryparser"
	"testing"
)



func TestMain(m *testing.M) {

	q, error := queryparser.Parse("  aa  =     3    ")
	if error != nil {
		fmt.Println(error)
		return
	}
	fmt.Println(*q)

}
