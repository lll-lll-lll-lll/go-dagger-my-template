package main

import (
	"net/http"

	"github.com/go-dagger/api/router"
	"github.com/go-dagger/controller"
	"github.com/go-dagger/model/repository"
)

var todoRepository = repository.NewTodoRepository()
var todoContoroller = controller.NewTodoController(todoRepository)
var todoRouter = router.NewRouter(todoContoroller)

func main() {
	server := http.Server{
		Addr: ":8080",
	}
	http.HandleFunc("/todos/", todoRouter.HandleTodosRequest)
	server.ListenAndServe()
}
