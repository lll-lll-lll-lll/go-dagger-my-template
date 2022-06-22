package repository

import (
	"database/sql"
	"fmt"
)

var Db *sql.DB

// dbの初期化
func init() {
	// docker-compose, Dockerfileの値を設定
	dbName := fmt.Sprintf("%s:%s@tcp(%s)/%s?charset=utf8",
		"todo-app", "todo-password", "sample-api-db:3306", "todo")
	Db, err := sql.Open("mysql", dbName)
	if err != nil {
		panic(Db)
	}
}
