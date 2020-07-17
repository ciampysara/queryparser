package tests

import (
	"fmt"
	"github.com/publicocean0/queryparser"
	"os"
	"testing"
)

func TestMain(m *testing.M) {
	src := "  aa       3    "
	q, exception := queryparser.Parse(src)
	if exception != nil {
		fmt.Println(exception.Error() + ":\r" + src + "\r" + exception.Cursor())
		return
	} else {
		fmt.Println(*q)
	}
	os.Exit(m.Run())

}
