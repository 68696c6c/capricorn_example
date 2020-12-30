// Code generated by "capricorn"; DO NOT EDIT.
package models

import (
	"github.com/68696c6c/capricorn-example/app/enums"

	"github.com/68696c6c/goat"
)

type User struct {
	goat.Model
	OrganizationId goat.ID        `binding:"required" json:"organizationid"`
	Email          string         `binding:"required" json:"email"`
	FirstName      string         `json:"first_name"`
	LastName       string         `json:"last_name"`
	Type           enums.UserType `json:"type"`
	Organization   *Organization  `json:"organization,omitempty"`
}