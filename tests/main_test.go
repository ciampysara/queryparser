package tests

import (
	"fmt"
	"github.com/publicocean0/queryparser"
	"os"
	"testing"
)

func TestMain(m *testing.M) {
	src := "  aa  <     \"10:11:12+13:14\"   "
	q, exception := queryparser.Parse(src)
	if exception != nil {
		fmt.Println(exception.Error() + ":\r\n" + src + "\r\n" + exception.Cursor())

	} else {
		fmt.Println(*q)
	}
	os.Exit(m.Run())

}
