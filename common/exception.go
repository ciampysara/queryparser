package common

type Exception struct {
	msg string
	pos int
}

func (l *Exception) Init(p int, s string) Exception {
	l.pos = p
	l.msg = s

	return *l
}
func (l *Exception) Error() string {
	return l.msg
}
func (l *Exception) Position() int {
	return l.pos
}
