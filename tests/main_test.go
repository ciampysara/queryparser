package tests

import (
	"fmt"
	"github.com/publicocean0/queryparser"
	"testing"
)



func TestMain(m *testing.M) {

	q, error := queryparser.Parse("   r = 2010-05-02T10:32Z        ")
	if error != nil {
		fmt.Println(error)
		return
	}
	fmt.Println(*q)

}
