package router

import (
	"net/http"

	"github.com/go-dagger/controller"
)

type Router interface {
	HandleTodosRequest(w http.ResponseWriter, r *http.Request)
}

type router struct {
	todoContoroller controller.TodoContoroller
}

func NewRouter(todoContoroller controller.TodoContoroller) *router {
	return &router{todoContoroller}
}

func (ro *router) HandleTodosRequest(w http.ResponseWriter, r *http.Request) {
	// リクエストのメソッドによってメソッドを分ける
	switch r.Method {
	case "GET":
		ro.todoContoroller.GetTodos()
	case "POST":
		ro.todoContoroller.PostTodo(w, r)
	case "PUT":
		ro.todoContoroller.PutTodo(w, r)
	case "DELETE":
		ro.todoContoroller.DeleteTodo(w, r)
	default:
		w.WriteHeader(405)
	}
}
