package tests

import (
	"fmt"
	"queryparser"
	"testing"
)

type A interface{}
type AImpl struct {
	a string
}

func TestMain(m *testing.M) {

	q, error := queryparser.Parse("( prova = \"CIAO\" ) AND A > 3    ")
	if error != nil {
		fmt.Println(error)
		return
	}
	fmt.Println(*q)

}
