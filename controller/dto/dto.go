package dto

type TodoResponse struct {
	ID      int    `jsong:"id"`
	Title   string `jsong:"title"`
	Content string `jsong:"content"`
}

type TodoRequest struct {
	Title   string `jsong:"title"`
	Content string `jsong:"content"`
}

type TodosResponse struct {
	Todos []TodoResponse `json:"todos"`
}
