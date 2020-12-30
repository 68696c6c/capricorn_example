// Code generated by "capricorn"; DO NOT EDIT.
package migrations

import (
	"database/sql"

	"github.com/68696c6c/capricorn-example/app/models"

	"github.com/68696c6c/goat"
	"github.com/pkg/errors"
	"github.com/pressly/goose"
)

func init() {
	goose.AddMigration(Up20201127164400, Down20201127164400)
}

func Up20201127164400(tx *sql.Tx) error {
	goat.Init()

	db, err := goat.GetMigrationDB()
	if err != nil {
		return errors.Wrap(err, "failed to initialize migration connection")
	}

	db.AutoMigrate(&models.Organization{})
	db.AutoMigrate(&models.User{})

	return nil
}

func Down20201127164400(tx *sql.Tx) error {
	goat.Init()

	db, err := goat.GetMigrationDB()
	if err != nil {
		return errors.Wrap(err, "failed to initialize migration connection")
	}

	db.AutoMigrate(&models.Organization{})
	db.AutoMigrate(&models.User{})

	return nil
}