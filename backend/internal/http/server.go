package http

import "net/http"

func NewServer() *http.ServeMux {
    mux := http.NewServeMux()
    mux.HandleFunc("/scores", CreateScoreHandler)
    return mux
}
