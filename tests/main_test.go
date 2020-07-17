package tests

import (
	"fmt"
	"github.com/publicocean0/queryparser"
	"testing"
)

func TestMain(m *testing.M) {

	q, exception := queryparser.Parse("  aa       3    ")
	if exception != nil {
		fmt.Println(exception.Error() + "\r" + exception.Cursor())
		return
	}
	fmt.Println(*q)

}
