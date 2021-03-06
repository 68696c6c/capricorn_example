// Code generated by "capricorn"; DO NOT EDIT.
package enums

import (
	"database/sql/driver"
	"fmt"

	"github.com/pkg/errors"
)

//go:generate stringer -type=UserType -trimprefix=UserType
type UserType int

const (
	UserTypeUser UserType = iota + 1
	UserTypeAdmin
	UserTypeSuper
)

func (i *UserType) Scan(input interface{}) error {
	stringValue := fmt.Sprintf("%v", input)
	result, err := UserTypeFromString(stringValue)
	if err != nil {
		return err
	}
	*i = result
	return nil
}

func (i *UserType) Value() (driver.Value, error) {
	return i.String(), nil
}

func UserTypeFromString(input string) (UserType, error) {
	switch input {
	case UserTypeUser.String():
		return UserTypeUser, nil
	case UserTypeAdmin.String():
		return UserTypeAdmin, nil
	case UserTypeSuper.String():
		return UserTypeSuper, nil
	default:
		return 0, errors.Errorf("invalid user type value '%s'", input)
	}
}
