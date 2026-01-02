package main

import (
    "log"
    "net/http"

    internalhttp "jumper-api/internal/http"
)

func main() {
    server := internalhttp.NewServer()

    log.Println("Backend listening on :8080")
    log.Fatal(http.ListenAndServe(":8080", server))
}
