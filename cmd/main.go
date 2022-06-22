package main

import (
	"net/http"

	"github.com/lll-lll-lll-lll/go-dagger/controller"
	"github.com/lll-lll-lll-lll/go-dagger/repository"
)

var todoRepository = repository.NewTodoRepository()
var todoContoroller = controller.NewTodoController(todoRepository)
var todoRouter = controller.NewRouter(todoContoroller)

func main() {
	server := http.Server{
		Addr: ":8080",
	}
	http.HandleFunc("/todos/", todoRouter.HandleTodosRequest)
	server.ListenAndServe()
}
