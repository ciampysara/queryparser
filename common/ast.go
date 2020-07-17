package common

import (
	"errors"
	"fmt"
	"strconv"
	"strings"
)

type Token struct {
	Position int
	Token    int
	Literal  string
}
type TokenValue struct {
	Token   int
	Content interface{}
}
type Condition struct {
	Variable   Token
	Comparator Token
	Value      TokenValue
}

type Date struct {
	day   uint8
	month uint8
	year  uint16
}

type Time struct {
	hour        uint8
	minutes     uint8
	seconds     uint8
	zoneHour    int8
	zoneMinutes uint8
}

type DateTime struct {
	date Date
	time Time
}

func daysInMonth(m uint8, y uint16) uint8 { // m is 0 indexed: 0-11
	switch m {
	case 1:
		if (y%4 == 0 && y%100 == 0) || y%400 == 0 {
			return 29
		} else {
			return 28
		}

	case 8:
		fallthrough
	case 3:
		fallthrough
	case 5:
		fallthrough
	case 10:
		return 30

	default:
		return 31
	}
}

func (l *Date) Parse(s string) error {
	t := strings.Split(s, "-")
	y, _ := strconv.ParseUint(t[0], 10, 16)
	m, _ := strconv.ParseUint(t[1], 10, 8)
	d, _ := strconv.ParseUint(t[2], 10, 8)
	return l.Set(uint16(y), uint8(m), uint8(d))

}

func (l *Date) Set(year uint16, month, day uint8) error {
	if month > 11 {
		return errors.New("invalid month")
	}
	if day >= daysInMonth(month, year) {
		return errors.New("invalid day")
	}
	l.year = year
	l.month = month
	l.day = day
	return nil
}
func (l *Date) Day() uint8 {
	return l.day
}
func (l *Date) Year() uint16 {
	return l.year
}
func (l *Date) Month() uint8 {
	return l.month
}
func (l *Date) String() string {
	str := fmt.Sprintf("%d-%d-%d", l.year, l.month, l.day)
	return str
}
func (l *DateTime) Date() Date {
	return l.Date()
}
func (l *DateTime) Time() Time {
	return l.Time()
}
func (l DateTime) String() string {

	return l.date.String() + " " + l.time.String()
}

func (l *DateTime) Set(date Date, time Time) {
	l.date = date
	l.time = time
}
func (l *Time) Set(hour, min, sec, zhour, zmin uint8) error {
	if hour >= 24 {
		return errors.New("invalid hour")
	}
	if min >= 60 {
		return errors.New("invalid minutes")
	}
	if sec >= 60 {
		return errors.New("invalid seconds")
	}
	if zmin >= 60 {
		return errors.New("invalid zone minutes")
	}
	return nil
}
func ParseTime(str string) (*Time, error) {
	t := Time{}
	e := t.Parse(str)
	if e != nil {
		return nil, e
	}
	return &t, nil
}
func ParseDate(str string) (*Date, error) {
	t := Date{}
	e := t.Parse(str)
	if e != nil {
		return nil, e
	}
	return &t, nil
}
func (l *Time) Parse(str string) error {
	i := strings.IndexAny(str, "+")
	if i == -1 {
		i = strings.IndexAny(str, "-")
	}
	t := strings.Split(str[0:i], ":")
	h, _ := strconv.ParseUint(t[0], 10, 8)
	m, _ := strconv.ParseUint(t[1], 10, 8)
	s, _ := strconv.ParseUint(t[2], 10, 8)
	z := strings.Split(str[i:], ":")
	zh, _ := strconv.ParseUint(z[0], 10, 8)
	zm, _ := strconv.ParseUint(z[1], 10, 8)
	return l.Set(uint8(h), uint8(m), uint8(s), uint8(zh), uint8(zm))

}
func (l *Time) Hour() uint8 {
	return l.hour
}
func (l *Time) Minutes() uint8 {
	return l.minutes
}
func (l *Time) Seconds() uint8 {
	return l.seconds
}
func (l *Time) ZoneMinutes() uint8 {
	return l.zoneMinutes
}
func (l *Time) ZoneHour() int8 {
	return l.zoneHour
}
func (l *Time) String() string {
	str := fmt.Sprintf("%d:%d:%d", l.hour, l.minutes, l.seconds)
	if l.zoneHour >= 0 {
		str += "+"
	} else {
		str += "-"
	}
	return str + fmt.Sprintf("%d:%d", l.zoneHour, l.zoneMinutes)
}

func (l Condition) String() string {
	str := fmt.Sprintf("%v", l.Value.Content)
	return l.Variable.Literal + " " + l.Comparator.Literal + " " + str
}

type Expression interface {
	String() string
}

type SubExpression struct {
	Expr Expression
}

func (l SubExpression) String() string {
	return "(" + (l.Expr).String() + ")"
}

type NotExpression struct {
	Expr Expression
}

func (l NotExpression) String() string {
	return "(" + (l.Expr).String() + ")"
}

type BiExpression struct {
	BooleanOperator Token
	Left            Expression
	Right           Expression
}

func (l BiExpression) String() string {
	return (l.Left).String() + " " + (l.BooleanOperator).Literal + " " + (l.Right).String()
}
