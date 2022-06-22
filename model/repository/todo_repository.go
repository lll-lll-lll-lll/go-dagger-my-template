package repository

import "github.com/go-dagger/model/entity"

type TodoRepository interface {
	GetTodos() (todos []entity.TodoEntity, err error)
	InsertTodo(todo entity.TodoEntity) (id int, err error)
	UpdateTodo(todo entity.TodoEntity) (err error)
	DeleteTodo(id int) (err error)
}

type todoRepository struct {
}

// TodoRepositoryのコンストラクタ。TodoRepository構造体のポインタを返却する。
func NewTodoRepository() TodoRepository {
	return &todoRepository{}
}

func (tr *todoRepository) GetTodos() (todos []entity.TodoEntity, err error) {}

func (tr *todoRepository) InsertTodo(todo entity.TodoEntity) (id int, err error) {}

func (tr *todoRepository) UpdateTodo(todo entity.TodoEntity) (err error) {}

func (tr *todoRepository) DeleteTodo(id int) (err error) {}
