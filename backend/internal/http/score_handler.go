package http

import (
	"encoding/json"
	"log"
	"net/http"

	"jumper-api/internal/domain"
)

func CreateScoreHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	log.Println("POST /scores received")

	var score domain.Score

	if err := json.NewDecoder(r.Body).Decode(&score); err != nil {
		log.Println("Invalid JSON payload")
		http.Error(w, "invalid payload", http.StatusBadRequest)
		return
	}

	if len(score.Nickname) < 3 || score.Score < 0 {
		log.Printf("Invalid data: nick=%q score=%d\n", score.Nickname, score.Score)
		http.Error(w, "invalid data", http.StatusBadRequest)
		return
	}

	log.Printf("Score accepted: nick=%q score=%d\n", score.Nickname, score.Score)

	w.WriteHeader(http.StatusCreated)
}
