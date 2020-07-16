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

	q, error := queryparser.Parse(" vae = 23:10:30Z ")
	if error != nil {
		fmt.Println(error)
		return
	}
	fmt.Println(*q)

}
