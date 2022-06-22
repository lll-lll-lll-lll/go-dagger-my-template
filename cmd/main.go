package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/gorilla/mux"
)

func main() {
	r := mux.NewRouter()
	httpPort := os.Getenv("HTTP_PORT")
	if httpPort == "" {
		httpPort = "8080"
	}
	r.HandleFunc("/", sampleHandler1).Methods("GET")
}

func sampleHandler1(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "hello sample")
}
