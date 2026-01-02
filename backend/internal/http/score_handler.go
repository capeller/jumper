package http

import (
    "encoding/json"
    "net/http"

    "jumper-api/internal/domain"
)

func CreateScoreHandler(w http.ResponseWriter, r *http.Request) {
    if r.Method != http.MethodPost {
        http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
        return
    }

    var score domain.Score

    if err := json.NewDecoder(r.Body).Decode(&score); err != nil {
        http.Error(w, "invalid payload", http.StatusBadRequest)
        return
    }

    if len(score.Nickname) < 3 || score.Score < 0 {
        http.Error(w, "invalid data", http.StatusBadRequest)
        return
    }

    w.WriteHeader(http.StatusCreated)
}
