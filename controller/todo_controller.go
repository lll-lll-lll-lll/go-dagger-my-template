package controller

import (
	"encoding/json"
	"net/http"
	"path"
	"strconv"

	"github.com/go-dagger/controller/dto"
	"github.com/go-dagger/model/entity"
	"github.com/go-dagger/repository"
)

type TodoController interface {
	GetTodos(w http.ResponseWriter, r *http.Request)
	PostTodo(w http.ResponseWriter, r *http.Request)
	PutTodo(w http.ResponseWriter, r *http.Request)
	DeleteTodo(w http.ResponseWriter, r *http.Request)
}

type todoController struct {
	tr repository.TodoRepository
}

// インターフェースTodoControllerを継承してる。メソッドを実装してないとエラーが返ってくる
func NewTodoController(tr repository.TodoRepository) TodoController {
	return &todoController{tr}
}

// Todoの取得
func (tc *todoController) GetTodos(w http.ResponseWriter, r *http.Request) {
	todos, err := tc.tr.GetTodos()
	if err != nil {
		w.WriteHeader(500)
		return
	}
	var todoResponses []dto.TodoResponse
	for _, v := range todos {
		todoResponses = append(todoResponses, dto.TodoResponse{ID: v.Id, Title: v.Title, Content: v.Content})
	}

	var todosResponse dto.TodosResponse
	todosResponse.Todos = todoResponses

	// jsonに変換
	output, _ := json.MarshalIndent(todosResponse.Todos, "", "\t\t")

	w.Header().Set("Content-Type", "application/json")
	w.Write(output)
}

// TODOの追加
func (tc *todoController) PostTodo(w http.ResponseWriter, r *http.Request) {
	body := make([]byte, r.ContentLength)
	r.Body.Read(body)
	var todoRequest dto.TodoRequest
	json.Unmarshal(body, &todoRequest)

	todo := entity.TodoEntity{Title: todoRequest.Title, Content: todoRequest.Content}

	id, err := tc.tr.InsertTodo(todo)
	if err != nil {
		w.WriteHeader(500)
		return
	}
	w.Header().Set("Location", r.Host+r.URL.Path+strconv.Itoa(id))
	w.WriteHeader(201)
}

// TODOの更新
func (tc *todoController) PutTodo(w http.ResponseWriter, r *http.Request) {
	todoId, err := strconv.Atoi(path.Base(r.URL.Path))
	if err != nil {
		w.WriteHeader(400)
		return
	}

	body := make([]byte, r.ContentLength)
	r.Body.Read(body)
	var todoRequest dto.TodoRequest
	json.Unmarshal(body, &todoRequest)
	todo := entity.TodoEntity{Id: todoId, Title: todoRequest.Title}

	err = tc.tr.UpdateTodo(todo)
	if err != nil {
		w.WriteHeader(500)
		return
	}

	w.WriteHeader(204)
}

// TODOの削除
func (tc *todoController) DeleteTodo(w http.ResponseWriter, r *http.Request) {
	todoId, err := strconv.Atoi(path.Base(r.URL.Path))
	if err != nil {
		w.WriteHeader(400)
		return
	}

	// リポジトリの削除処理呼び出し
	err = tc.tr.DeleteTodo(todoId)
	if err != nil {
		w.WriteHeader(500)
		return
	}
	w.WriteHeader(204)
}
